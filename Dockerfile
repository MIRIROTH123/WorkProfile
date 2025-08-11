# שלב 1: בניית סביבה עם כל התלויות
FROM python:3.9-slim AS build

# תיקיית עבודה
WORKDIR /app

# התקנת כלים נדרשים להרכבת חבילות (אם יש)
RUN apt-get update && apt-get install -y \
    build-essential \
    default-libmysqlclient-dev \
    pkg-config \
 && rm -rf /var/lib/apt/lists/*

# העתקת קובץ הדרישות
COPY requirements.txt .

# התקנת חבילות Python לתיקייה במערכת הקבצים (בברירת מחדל /usr/local)
RUN pip install --prefix=/install --no-cache-dir -r requirements.txt

# שלב 2: סביבה קטנה להרצת האפליקציה בלבד
FROM python:3.9-alpine

# תיקיית עבודה
WORKDIR /app

# העתקת החבילות שהותקנו בשלב הקודם
COPY --from=build /install /usr/local

# העתקת קבצי האפליקציה
COPY static ./static
COPY templates ./templates
COPY app.py .
COPY dbcontext.py .
COPY person.py .

# חשיפת הפורט שהאפליקציה מאזינה עליו (5000)
EXPOSE 5000

# פקודת ההרצה
CMD ["python", "app.py"]
