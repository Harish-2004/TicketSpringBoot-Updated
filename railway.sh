#!/bin/sh

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

# Check database connection
echo "Checking database connection..."
max_attempts=5
attempt=1

while [ $attempt -le $max_attempts ]; do
    if PGPASSWORD=$PGPASSWORD psql "host=$DB_HOST port=$DB_PORT dbname=$DB_NAME user=$DB_USER sslmode=require" -c '\q' 2>&1; then
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

# Start the application
echo "Starting Spring Boot application..."
exec java -Xms256m -Xmx512m \
     -Dspring.profiles.active=cloud \
     -Dspring.datasource.url="$DATABASE_URL" \
     -Dserver.port="${PORT:-8080}" \
     -jar app.jar 