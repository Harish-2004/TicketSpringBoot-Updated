#!/bin/bash

# Wait for PostgreSQL to be ready
echo "Waiting for PostgreSQL to be ready..."
sleep 30

# Check if we can connect to the database
echo "Checking database connection..."
until PGPASSWORD=$PGPASSWORD psql -h $PGHOST -U $PGUSER -d $PGDATABASE -c '\q'; do
  echo "PostgreSQL is unavailable - sleeping"
  sleep 5
done

echo "PostgreSQL is up - executing command"

# Run the application with proper JVM options
echo "Starting Spring Boot application..."
java -Xms512m -Xmx1024m \
     -Dspring.profiles.active=cloud \
     -Dspring.datasource.url=$DATABASE_URL \
     -Dspring.datasource.username=$PGUSER \
     -Dspring.datasource.password=$PGPASSWORD \
     -jar app.jar 