# שלב בנייה
FROM python:3.9-slim AS builder
WORKDIR /app

# התקנת תלויות מערכת עבור mysqlclient
RUN apt-get update && apt-get install -y \
    default-libmysqlclient-dev \
    build-essential \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY static/ ./static/
COPY templates/ ./templates/
COPY app.py . 
COPY dbcontext.py . 
COPY person.py .

# שלב הריצה
FROM python:3.9-alpine
WORKDIR /app

# העתקת ספריות פייתון מה־builder
COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages
COPY --from=builder /app /app

EXPOSE 5000
CMD ["python", "app.py"]
