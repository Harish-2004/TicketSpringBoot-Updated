#!/bin/sh

# Wait for PostgreSQL to be ready
echo "Waiting for PostgreSQL to be ready..."
sleep 30

# Extract database connection details from DATABASE_URL
DB_URL=$(echo $DATABASE_URL | sed 's/postgres:\/\///')
DB_HOST=$(echo $DB_URL | cut -d@ -f2 | cut -d: -f1)
DB_PORT=$(echo $DB_URL | cut -d: -f2 | cut -d/ -f1)
DB_NAME=$(echo $DB_URL | cut -d/ -f2 | cut -d? -f1)

echo "Database connection details:"
echo "Host: $DB_HOST"
echo "Port: $DB_PORT"
echo "Database: $DB_NAME"

# Check if we can connect to the database
echo "Checking database connection..."
max_attempts=30
attempt=1

while [ $attempt -le $max_attempts ]; do
    if PGPASSWORD=$PGPASSWORD psql "host=$DB_HOST port=$DB_PORT dbname=$DB_NAME user=$PGUSER sslmode=require" -c '\q' 2>/dev/null; then
        echo "PostgreSQL is up - executing command"
        break
    fi
    
    echo "PostgreSQL is unavailable - sleeping (attempt $attempt of $max_attempts)"
    sleep 5
    attempt=$((attempt + 1))
done

if [ $attempt -gt $max_attempts ]; then
    echo "Could not connect to PostgreSQL after $max_attempts attempts. Starting application anyway..."
fi

# Run the application with proper JVM options
echo "Starting Spring Boot application..."
exec java -Xms512m -Xmx1024m \
     -Dspring.profiles.active=cloud \
     -Dspring.datasource.url="$DATABASE_URL?sslmode=require" \
     -Dspring.datasource.username="$PGUSER" \
     -Dspring.datasource.password="$PGPASSWORD" \
     -jar app.jar 