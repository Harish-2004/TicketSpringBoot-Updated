#!/bin/sh

# Wait for PostgreSQL to be ready
echo "Waiting for PostgreSQL to be ready..."
sleep 30

# Set default values if not provided
export PGHOST=${PGHOST:-postgres.railway.internal}
export PGPORT=${PGPORT:-5432}
export PGUSER=${PGUSER:-postgres}
export PGDATABASE=${PGDATABASE:-railway}

# Debug: Print environment variables (masking sensitive data)
echo "Environment variables:"
echo "PGHOST: $PGHOST"
echo "PGPORT: $PGPORT"
echo "PGUSER: $PGUSER"
echo "PGDATABASE: $PGDATABASE"
echo "DATABASE_URL: ${DATABASE_URL:+set}"

# Construct connection string
CONN_STRING="host=$PGHOST port=$PGPORT dbname=$PGDATABASE user=$PGUSER sslmode=require"

echo "Using connection string: $CONN_STRING"

# Check if we can connect to the database
echo "Checking database connection..."
max_attempts=30
attempt=1

while [ $attempt -le $max_attempts ]; do
    echo "Attempt $attempt of $max_attempts..."
    
    if PGPASSWORD=$PGPASSWORD psql "$CONN_STRING" -c '\q' 2>/dev/null; then
        echo "Successfully connected to PostgreSQL!"
        break
    fi
    
    echo "PostgreSQL is unavailable - sleeping..."
    sleep 5
    attempt=$((attempt + 1))
done

if [ $attempt -gt $max_attempts ]; then
    echo "Could not connect to PostgreSQL after $max_attempts attempts. Starting application anyway..."
fi

# Run the application with proper JVM options
echo "Starting Spring Boot application..."
echo "Using DATABASE_URL: ${DATABASE_URL:+set}"
echo "Using PGUSER: $PGUSER"
echo "Using PORT: ${PORT:-8080}"

exec java -Xms512m -Xmx1024m \
     -Dspring.profiles.active=cloud \
     -Dspring.datasource.url="$DATABASE_URL?sslmode=require" \
     -Dspring.datasource.username="$PGUSER" \
     -Dspring.datasource.password="$PGPASSWORD" \
     -Dserver.port="${PORT:-8080}" \
     -jar app.jar 