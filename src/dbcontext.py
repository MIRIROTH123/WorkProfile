from typing import List
import mysql.connector
from os import environ
from person import Person
from flask import Response, jsonify
import time

db_user = environ.get('DB_USER')
db_pass = environ.get('DB_PASS')
db_host = environ.get('DB_HOST')
db_name = environ.get('DB_NAME')

config = {
    "host": db_host,
    "user": db_user,
    "password": db_pass,
    "database": db_name,
    "port": 3306
}

def demo_data() -> List[Person]:
    person1 = Person(1, "John", "Doe", 30, "76 Ninth Avenue St, New York, NY 10011, USA", "Google")
    person2 = Person(2, "Jane", "Doe", 28, "15 Aabogade St, Aarhus, Denmark 8200", "Microsoft")
    person3 = Person(3, "Jack", "Doe", 25, "98 Yigal Alon St, Tel Aviv, Israel 6789141", "Amazon")
    return [person1, person2, person3]

def health_check(retries: int = 10, delay: int = 3) -> bool:
    if not db_host:
        return True

    for attempt in range(retries):
        try:
            cnx = mysql.connector.connect(**config)
            if cnx.is_connected():
                cnx.close()
                return True
        except mysql.connector.Error:
            print(f"MySQL not ready, waiting {delay} seconds... (Attempt {attempt + 1}/{retries})")
            time.sleep(delay)
    return False

def db_data() -> List[Person]:
    if not db_host:
        return demo_data()

    if not (db_user and db_pass):
        raise Exception("DB_USER and DB_PASS are not set")

    for attempt in range(10):
        try:
            cnx = mysql.connector.connect(**config)
            result: List[Person] = []
            if cnx.is_connected():
                cursor = cnx.cursor()
                try:
                    cursor.execute("SELECT * FROM people")
                    for item in cursor:
                        result.append(Person(item[0], item[1], item[2], item[3], item[4], item[5]))
                    return result
                finally:
                    cursor.close()
                    cnx.close()
        except mysql.connector.Error:
            print(f"DB not ready, waiting 3 seconds... (Attempt {attempt + 1}/10)")
            time.sleep(3)
    return demo_data()

def db_delete(id: int) -> Response:
    if not db_host:
        return Response(status=200)

    status = 200
    for attempt in range(10):
        try:
            cnx = mysql.connector.connect(**config)
            if cnx.is_connected():
                cursor = cnx.cursor()
                try:
                    cursor.execute(f"DELETE FROM people WHERE id = {id}")
                    cnx.commit()
                    return Response(status=status)
                finally:
                    cursor.close()
                    cnx.close()
        except mysql.connector.Error:
            print(f"DB delete not ready, waiting 3 seconds... (Attempt {attempt + 1}/10)")
            time.sleep(3)
            status = 404
    return Response(status=status)

def db_add(person: Person):
    """
    מחזיר JSON עם ה-ID של האדם שנוסף, או 0 אם נכשל
    """
    if not db_host:
        return jsonify({"id": 999}), 200  # ערך דמה אם אין DB

    person_id = 0
    for attempt in range(10):
        try:
            cnx = mysql.connector.connect(**config)
            if cnx.is_connected():
                cursor = cnx.cursor()
                try:
                    # שימו לב לשמות עמודות לפי DB
                    cursor.execute(
                        "INSERT INTO people (firstname, lastname, age, address, workplace) "
                        "VALUES (%s, %s, %s, %s, %s)",
                        (person.first_name, person.last_name, person.age, person.address, person.workplace)
                    )
                    cnx.commit()
                    person_id = cursor.lastrowid
                    return jsonify({"id": person_id}), 200
                finally:
                    cursor.close()
                    cnx.close()
        except mysql.connector.Error:
            print(f"DB add not ready, waiting 3 seconds... (Attempt {attempt + 1}/10)")
            time.sleep(3)
            person_id = 0
    return jsonify({"id": person_id}), 200
