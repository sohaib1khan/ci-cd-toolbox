#!/bin/bash

# Variables
APP_NAME="DashLink"
IMAGE_NAME="DashLink"
CONTAINER_NAME="dashlink"
PORT=5021

HOST_IP=$(hostname -I | awk '{print $1}')

# Create Dockerfile
echo "Creating Dockerfile..."
cat <<EOL > Dockerfile
# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container
COPY . /app

# Install any necessary dependencies
RUN pip install --no-cache-dir flask

# Expose the application's port
EXPOSE 5021

# Start the application using python
CMD ["python", "app.py"]

EOL

# Launch with skaffold
echo "Launching with skaffold..."

skaffold run
