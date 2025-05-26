#!/bin/sh

# Wait for PostgreSQL to be ready
echo "Waiting for PostgreSQL to be ready..."
sleep 30

# Set default values if not provided
export PGHOST=${PGHOST:-postgres.railway.internal}
export PGPORT=${PGPORT:-5432}
export PGUSER=${PGUSER:-postgres}
export PGDATABASE=${PGDATABASE:-railway}

# Enable PostgreSQL client logging
export PGSSLMODE=require
export PGSSLCERT=/etc/ssl/certs/ca-certificates.crt
export PGSSLROOTCERT=/etc/ssl/certs/ca-certificates.crt

# Debug: Print environment variables (masking sensitive data)
echo "Environment variables:"
echo "PGHOST: $PGHOST"
echo "PGPORT: $PGPORT"
echo "PGUSER: $PGUSER"
echo "PGDATABASE: $PGDATABASE"
echo "DATABASE_URL: ${DATABASE_URL:+set}"
echo "PGSSLMODE: $PGSSLMODE"

# Try to ping the host first
echo "Testing host connectivity..."
if ping -c 1 $PGHOST > /dev/null 2>&1; then
    echo "Host is reachable"
else
    echo "Warning: Cannot ping host $PGHOST"
fi

# Test DNS resolution
echo "Testing DNS resolution..."
nslookup $PGHOST

# Construct connection string with all possible parameters
CONN_STRING="host=$PGHOST port=$PGPORT dbname=$PGDATABASE user=$PGUSER sslmode=require connect_timeout=10"

echo "Using connection string: $CONN_STRING"

# Check if we can connect to the database
echo "Checking database connection..."
max_attempts=30
attempt=1

while [ $attempt -le $max_attempts ]; do
    echo "Attempt $attempt of $max_attempts..."
    
    # Try connection with error output and debug logging
    if PGPASSWORD=$PGPASSWORD psql -v ON_ERROR_STOP=1 "$CONN_STRING" -c '\q' 2>&1; then
        echo "Successfully connected to PostgreSQL!"
        break
    else
        echo "Connection failed. Error details:"
        PGPASSWORD=$PGPASSWORD psql -v ON_ERROR_STOP=1 "$CONN_STRING" -c '\q' 2>&1
    fi
    
    echo "PostgreSQL is unavailable - sleeping..."
    sleep 5
    attempt=$((attempt + 1))
done

if [ $attempt -gt $max_attempts ]; then
    echo "Could not connect to PostgreSQL after $max_attempts attempts. Starting application anyway..."
    echo "Last connection attempt details:"
    PGPASSWORD=$PGPASSWORD psql -v ON_ERROR_STOP=1 "$CONN_STRING" -c '\q' 2>&1
fi

# Run the application with proper JVM options
echo "Starting Spring Boot application..."
echo "Using DATABASE_URL: ${DATABASE_URL:+set}"
echo "Using PGUSER: $PGUSER"
echo "Using PORT: ${PORT:-8080}"

# Add debug logging for database connection
exec java -Xms512m -Xmx1024m \
     -Dspring.profiles.active=cloud \
     -Dspring.datasource.url="$DATABASE_URL?sslmode=require" \
     -Dspring.datasource.username="$PGUSER" \
     -Dspring.datasource.password="$PGPASSWORD" \
     -Dserver.port="${PORT:-8080}" \
     -Dlogging.level.org.postgresql=DEBUG \
     -Dlogging.level.com.zaxxer.hikari=DEBUG \
     -Dlogging.level.org.hibernate=DEBUG \
     -Dlogging.level.org.springframework=DEBUG \
     -Dlogging.level.org.springframework.jdbc=DEBUG \
     -jar app.jar 