FROM python:3.9-slim AS builder

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    git \
    vim \
    bash

# Set working directory
WORKDIR /app

COPY ./requirements.txt /app
COPY ./app/wsgi.ini /app/wsgi.ini
COPY ./app/wsgi.py /app/wsgi.py
COPY app/app.py /app/app.py
COPY ./app/static/swagger/swagger.json /app/static/swagger/swagger.json

RUN pip install -r /app/requirements.txt

# Copy the rest of the application
COPY . .

# Set environment variables
ENV PYTHONUNBUFFERED=1

EXPOSE 5000
CMD ["uwsgi", "--ini", "/app/wsgi.ini"]
