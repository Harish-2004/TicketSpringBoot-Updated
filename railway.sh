#!/bin/sh

# Wait for PostgreSQL to be ready
echo "Waiting for PostgreSQL to be ready..."
sleep 30

# Log all environment variables (excluding sensitive ones)
echo "Environment variables:"
echo "DATABASE_URL: ${DATABASE_URL:+set}"
echo "PGUSER: ${PGUSER:+set}"
echo "PGHOST: ${PGHOST:+set}"
echo "PGPORT: ${PGPORT:+set}"
echo "PGDATABASE: ${PGDATABASE:+set}"
echo "PORT: ${PORT:-8080}"

# Extract database connection details from DATABASE_URL if available
if [ -n "$DATABASE_URL" ]; then
    DB_URL=$(echo $DATABASE_URL | sed 's/postgres:\/\///')
    DB_HOST=$(echo $DB_URL | cut -d@ -f2 | cut -d: -f1)
    DB_PORT=$(echo $DB_URL | cut -d: -f2 | cut -d/ -f1)
    DB_NAME=$(echo $DB_URL | cut -d/ -f2 | cut -d? -f1)
else
    # Use individual environment variables if DATABASE_URL is not available
    DB_HOST=${PGHOST:-localhost}
    DB_PORT=${PGPORT:-5432}
    DB_NAME=${PGDATABASE:-postgres}
fi

echo "Database connection details:"
echo "Host: $DB_HOST"
echo "Port: $DB_PORT"
echo "Database: $DB_NAME"
echo "User: $PGUSER"

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
    echo "Connection details used:"
    echo "host=$DB_HOST port=$DB_PORT dbname=$DB_NAME user=$PGUSER sslmode=require"
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
     -Dserver.port="${PORT:-8080}" \
     -jar app.jar 