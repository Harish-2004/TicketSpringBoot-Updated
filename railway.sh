#!/bin/sh

# Exit on error
set -e

# Wait for PostgreSQL to be ready
echo "Waiting for PostgreSQL to be ready..."
sleep 5

# Check if DATABASE_URL is set
if [ -z "$DATABASE_URL" ]; then
    echo "Error: DATABASE_URL is not set"
    exit 1
fi

# Print masked DATABASE_URL for debugging
MASKED_URL=$(echo "$DATABASE_URL" | sed -E 's/(:\/\/[^:]+:)[^@]+(@)/\1****\2/')
echo "Using DATABASE_URL: $MASKED_URL"

# Enable PostgreSQL client logging
export PGSSLMODE=require

# Extract connection details from DATABASE_URL
DB_HOST=$(echo $DATABASE_URL | sed -n 's/.*@\([^:]*\).*/\1/p')
DB_PORT=$(echo $DATABASE_URL | sed -n 's/.*:\([0-9]*\)\/.*/\1/p')
DB_NAME=$(echo $DATABASE_URL | sed -n 's/.*\/\([^?]*\).*/\1/p')
DB_USER=$(echo $DATABASE_URL | sed -n 's/.*:\/\/\([^:]*\):.*/\1/p')
DB_PASSWORD=$(echo $DATABASE_URL | sed -n 's/.*:\/\/[^:]*:\([^@]*\)@.*/\1/p')

# Export database credentials for Spring Boot
export DB_USERNAME=$DB_USER
export DB_PASSWORD=$DB_PASSWORD

# Check database connection
echo "Checking database connection..."
max_attempts=5
attempt=1

while [ $attempt -le $max_attempts ]; do
    if PGPASSWORD=$DB_PASSWORD psql "host=$DB_HOST port=$DB_PORT dbname=$DB_NAME user=$DB_USER sslmode=require" -c '\q' 2>&1; then
        echo "Successfully connected to PostgreSQL!"
        break
    fi
    
    echo "Attempt $attempt of $max_attempts failed. Retrying..."
    sleep 2
    attempt=$((attempt + 1))
done

if [ $attempt -gt $max_attempts ]; then
    echo "Could not connect to PostgreSQL after $max_attempts attempts. Starting application anyway..."
fi

# Start the application with proper error handling
echo "Starting Spring Boot application..."
exec java \
    -Dspring.profiles.active=cloud \
    -Dspring.datasource.url="jdbc:postgresql://${DB_HOST}:${DB_PORT}/${DB_NAME}" \
    -Dspring.datasource.username="${DB_USER}" \
    -Dspring.datasource.password="${DB_PASSWORD}" \
    -Dserver.port="${PORT:-8080}" \
    -Dlogging.level.org.springframework=INFO \
    -Dlogging.level.org.hibernate=INFO \
    -Dlogging.level.com.zaxxer.hikari=INFO \
    -Dlogging.level.org.postgresql=INFO \
    -Dspring.main.banner-mode=log \
    -Dspring.main.log-startup-info=true \
    -jar app.jar 