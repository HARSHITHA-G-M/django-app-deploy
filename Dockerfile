FROM python:3.10-slim

WORKDIR /app

# Install PostgreSQL headers and gcc
RUN apt-get update && apt-get install -y gcc libpq-dev

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the code
COPY . .

EXPOSE 8000

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]

