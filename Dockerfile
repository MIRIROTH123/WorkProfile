FROM python:3.9-slim AS builder

# התקנת כל התלויות הדרושות לבנייה
RUN apt-get update && apt-get install -y \
    build-essential \
    pkg-config \
    default-libmysqlclient-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY static/ ./static/
COPY templates/ ./templates/
COPY app.py .
COPY dbcontext.py .
COPY person.py .

# שלב הריצה - תמונה קטנה מבוססת Alpine
FROM python:3.9-alpine

WORKDIR /app

# מעתיק את ספריות הפייתון שהותקנו בשלב הבנייה
COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages

# מעתיק את כל הקבצים שהועתקו בשלב הבנייה
COPY --from=builder /app /app

EXPOSE 8080

CMD ["python", "app.py"]
