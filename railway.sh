#!/bin/sh

# Create a lock file to prevent multiple executions
LOCK_FILE="/app/.init_lock"
if [ -f "$LOCK_FILE" ]; then
    echo "Initialization already completed, skipping..."
    # Just start the application
    exec java -Xms512m -Xmx1024m \
         -Dspring.profiles.active=cloud \
         -Dspring.datasource.url="$DATABASE_URL" \
         -Dserver.port="${PORT:-8080}" \
         -Dlogging.level.org.postgresql=INFO \
         -Dlogging.level.com.zaxxer.hikari=INFO \
         -Dlogging.level.org.hibernate=INFO \
         -Dlogging.level.org.springframework=INFO \
         -Dlogging.level.org.springframework.jdbc=INFO \
         -jar app.jar
    exit 0
fi

# Wait for PostgreSQL to be ready
echo "Waiting for PostgreSQL to be ready..."
sleep 30

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

# Debug: Print environment variables (masking sensitive data)
echo "Environment variables:"
echo "DATABASE_URL: $MASKED_URL"
echo "PGSSLMODE: $PGSSLMODE"

# Extract connection details from DATABASE_URL
DB_HOST=$(echo $DATABASE_URL | sed -n 's/.*@\([^:]*\).*/\1/p')
DB_PORT=$(echo $DATABASE_URL | sed -n 's/.*:\([0-9]*\)\/.*/\1/p')
DB_NAME=$(echo $DATABASE_URL | sed -n 's/.*\/\([^?]*\).*/\1/p')
DB_USER=$(echo $DATABASE_URL | sed -n 's/.*:\/\/\([^:]*\):.*/\1/p')

echo "Extracted connection details:"
echo "Host: $DB_HOST"
echo "Port: $DB_PORT"
echo "Database: $DB_NAME"
echo "User: $DB_USER"

# Check if SQL file exists
SQL_FILE="/app/railway-setup.sql"
if [ ! -f "$SQL_FILE" ]; then
    echo "Warning: SQL file not found at $SQL_FILE"
    echo "Current directory contents:"
    ls -la /app/
    echo "Falling back to classpath SQL initialization"
fi

# Check if we can connect to the database
echo "Checking database connection..."
max_attempts=30
attempt=1

while [ $attempt -le $max_attempts ]; do
    echo "Attempt $attempt of $max_attempts..."
    
    # Try connection using the actual hostname from DATABASE_URL
    if PGPASSWORD=$PGPASSWORD psql "host=$DB_HOST port=$DB_PORT dbname=$DB_NAME user=$DB_USER sslmode=require" -c '\q' 2>&1; then
        echo "Successfully connected to PostgreSQL!"
        
        # Initialize database schema if SQL file exists
        if [ -f "$SQL_FILE" ]; then
            echo "Initializing database schema from $SQL_FILE..."
            # Drop existing tables if they exist
            PGPASSWORD=$PGPASSWORD psql "host=$DB_HOST port=$DB_PORT dbname=$DB_NAME user=$DB_USER sslmode=require" -c "
                DROP TABLE IF EXISTS passengerbooking CASCADE;
                DROP TABLE IF EXISTS supplementpassengers CASCADE;
                DROP TABLE IF EXISTS train CASCADE;
                DROP TABLE IF EXISTS login CASCADE;
            "
            # Run the initialization script
            PGPASSWORD=$PGPASSWORD psql "host=$DB_HOST port=$DB_PORT dbname=$DB_NAME user=$DB_USER sslmode=require" -f "$SQL_FILE"
            
            if [ $? -eq 0 ]; then
                echo "Database schema initialized successfully"
            else
                echo "Warning: Database schema initialization had some issues"
            fi
        else
            echo "Skipping direct SQL initialization, will use Spring Boot's initialization"
        fi
        
        break
    else
        echo "Connection failed. Error details:"
        PGPASSWORD=$PGPASSWORD psql "host=$DB_HOST port=$DB_PORT dbname=$DB_NAME user=$DB_USER sslmode=require" -c '\q' 2>&1
    fi
    
    echo "PostgreSQL is unavailable - sleeping..."
    sleep 5
    attempt=$((attempt + 1))
done

if [ $attempt -gt $max_attempts ]; then
    echo "Could not connect to PostgreSQL after $max_attempts attempts. Starting application anyway..."
fi

# Create lock file to indicate initialization is complete
touch "$LOCK_FILE"

# Run the application with proper JVM options
echo "Starting Spring Boot application..."
echo "Using DATABASE_URL: $MASKED_URL"
echo "Using PORT: ${PORT:-8080}"

# Add debug logging for database connection
exec java -Xms512m -Xmx1024m \
     -Dspring.profiles.active=cloud \
     -Dspring.datasource.url="$DATABASE_URL" \
     -Dserver.port="${PORT:-8080}" \
     -Dlogging.level.org.postgresql=INFO \
     -Dlogging.level.com.zaxxer.hikari=INFO \
     -Dlogging.level.org.hibernate=INFO \
     -Dlogging.level.org.springframework=INFO \
     -Dlogging.level.org.springframework.jdbc=INFO \
     -jar app.jar 