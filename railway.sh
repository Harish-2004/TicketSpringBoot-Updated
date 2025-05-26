#!/bin/bash

# Wait for PostgreSQL to be ready
echo "Waiting for PostgreSQL to be ready..."
sleep 10

# Run the application
echo "Starting Spring Boot application..."
java -jar app.jar 