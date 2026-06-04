# Use an official Python runtime as a parent image
FROM python:3.13-alpine

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Create the non-privileged user early
RUN adduser -D -h /home/container container

# Set work directory
WORKDIR /app

# Update the OS without caching package indexes to save space
RUN apk upgrade --no-cache \
    && apk add git --no-cache \
    && rm -rf /var/cache/apk/*

# Switch to the non-privileged user
USER container
ENV USER=container HOME=/home/container

# Set default container start command
CMD ["python", "main.py"]
