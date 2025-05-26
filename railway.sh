#!/bin/sh

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

# Try alternative connection methods
echo "Trying alternative connection methods..."

# Method 1: Using DATABASE_URL directly
echo "Method 1: Using DATABASE_URL directly"
if PGPASSWORD=$PGPASSWORD psql "$DATABASE_URL" -c '\q' 2>&1; then
    echo "Successfully connected using DATABASE_URL!"
    CONNECTION_METHOD="DATABASE_URL"
else
    echo "DATABASE_URL connection failed, trying alternative method..."
    
    # Method 2: Using individual components from DATABASE_URL
    DB_HOST=$(echo $DATABASE_URL | sed -n 's/.*@\([^:]*\).*/\1/p')
    DB_PORT=$(echo $DATABASE_URL | sed -n 's/.*:\([0-9]*\)\/.*/\1/p')
    DB_NAME=$(echo $DATABASE_URL | sed -n 's/.*\/\([^?]*\).*/\1/p')
    DB_USER=$(echo $DATABASE_URL | sed -n 's/.*:\/\/\([^:]*\):.*/\1/p')
    
    echo "Extracted connection details:"
    echo "Host: $DB_HOST"
    echo "Port: $DB_PORT"
    echo "Database: $DB_NAME"
    echo "User: $DB_USER"
    
    # Try connecting with individual components
    if PGPASSWORD=$PGPASSWORD psql "host=$DB_HOST port=$DB_PORT dbname=$DB_NAME user=$DB_USER sslmode=require" -c '\q' 2>&1; then
        echo "Successfully connected using individual components!"
        CONNECTION_METHOD="COMPONENTS"
    else
        echo "Individual components connection failed, trying final method..."
        
        # Method 3: Using Railway's internal DNS
        if PGPASSWORD=$PGPASSWORD psql "host=containers-us-west-207.railway.app port=$DB_PORT dbname=$DB_NAME user=$DB_USER sslmode=require" -c '\q' 2>&1; then
            echo "Successfully connected using Railway's internal DNS!"
            CONNECTION_METHOD="RAILWAY_DNS"
        else
            echo "All connection methods failed"
            CONNECTION_METHOD="FAILED"
        fi
    fi
fi

# Check if we can connect to the database
echo "Checking database connection..."
max_attempts=30
attempt=1

while [ $attempt -le $max_attempts ]; do
    echo "Attempt $attempt of $max_attempts..."
    
    case $CONNECTION_METHOD in
        "DATABASE_URL")
            if PGPASSWORD=$PGPASSWORD psql "$DATABASE_URL" -c '\q' 2>&1; then
                echo "Successfully connected to PostgreSQL!"
                break
            fi
            ;;
        "COMPONENTS")
            if PGPASSWORD=$PGPASSWORD psql "host=$DB_HOST port=$DB_PORT dbname=$DB_NAME user=$DB_USER sslmode=require" -c '\q' 2>&1; then
                echo "Successfully connected to PostgreSQL!"
                break
            fi
            ;;
        "RAILWAY_DNS")
            if PGPASSWORD=$PGPASSWORD psql "host=containers-us-west-207.railway.app port=$DB_PORT dbname=$DB_NAME user=$DB_USER sslmode=require" -c '\q' 2>&1; then
                echo "Successfully connected to PostgreSQL!"
                break
            fi
            ;;
        *)
            echo "No working connection method found"
            break
            ;;
    esac
    
    echo "PostgreSQL is unavailable - sleeping..."
    sleep 5
    attempt=$((attempt + 1))
done

if [ $attempt -gt $max_attempts ]; then
    echo "Could not connect to PostgreSQL after $max_attempts attempts. Starting application anyway..."
fi

# Run the application with proper JVM options
echo "Starting Spring Boot application..."
echo "Using DATABASE_URL: $MASKED_URL"
echo "Using PORT: ${PORT:-8080}"

# Add debug logging for database connection
exec java -Xms512m -Xmx1024m \
     -Dspring.profiles.active=cloud \
     -Dspring.datasource.url="$DATABASE_URL" \
     -Dserver.port="${PORT:-8080}" \
     -Dlogging.level.org.postgresql=DEBUG \
     -Dlogging.level.com.zaxxer.hikari=DEBUG \
     -Dlogging.level.org.hibernate=DEBUG \
     -Dlogging.level.org.springframework=DEBUG \
     -Dlogging.level.org.springframework.jdbc=DEBUG \
     -jar app.jar 