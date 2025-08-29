# Use an official OpenJDK 17 image
FROM eclipse-temurin:17-jre-alpine

# Set the working directory
WORKDIR /app

# Copy the built jar file (update the name if needed)
COPY target/demoWeb-0.0.1-SNAPSHOT.jar app.jar

# Expose the port your app runs on (default Spring Boot port is 8080)
EXPOSE 8080
ENV SPRING_PROFILES_ACTIVE=cloud
# Run the jar file
ENTRYPOINT ["java", "-jar", "app.jar"]