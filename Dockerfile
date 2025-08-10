FROM python:3.9

WORKDIR /app

# התקנת תלותות מערכת נדרשות
RUN apt-get update && apt-get install -y \
    build-essential \
    default-libmysqlclient-dev \
    pkg-config \
 && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY static ./static
COPY templates ./templates
COPY app.py .
COPY dbcontext.py .
COPY person.py .

EXPOSE 8080

CMD ["python", "app.py"]
