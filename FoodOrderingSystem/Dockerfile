# --- Stage 1: Build WAR file using Maven ---
FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app

# Copy project files
COPY pom.xml .
COPY src ./src

# Build WAR file, skip tests to speed up
RUN mvn clean package -DskipTests

# --- Stage 2: Run WAR file with embedded Tomcat (Spring Boot WAR) ---
FROM openjdk:17-jdk-slim
WORKDIR /app

# Copy WAR built from stage 1
COPY --from=build /app/target/*.war app.war

# Expose port Render will assign dynamically
ENV PORT=8080
EXPOSE 8080

# Set JVM to bind the port dynamically from Render.com
ENTRYPOINT ["java", "-Dserver.port=$PORT", "-jar", "app.war"]
