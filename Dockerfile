# Use an official Python runtime as a parent image
FROM python:3.13-alpine

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Create the non-privileged user early
RUN adduser -D -h /home/container container

# Set work directory
WORKDIR /home/container

# Update the OS without caching package indexes to save space
RUN apk upgrade --no-cache

# Copy only requirements first to leverage Docker layer caching
COPY requirements.txt ./

# Upgrade pip and install packages in a single layer to save space
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# Copy the app contents and set ownership in one step
# This prevents Docker from creating duplicate layers and doubling image size
COPY --chown=container:container . .

# Ensure the data directory exists with the correct permissions
RUN mkdir -p /home/container/data \
    && chown container:container /home/container/data

# Switch to the non-privileged user
USER container
ENV USER=container HOME=/home/container

# Set default container start command
CMD ["python", "main.py"]
