# Stage 1: Build WAR file using Maven
FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src src
RUN mvn clean package -DskipTests

# Stage 2: Run with embedded Tomcat
FROM openjdk:17-jdk-slim
WORKDIR /app
COPY --from=build /app/target/*.war app.war

# Render injects PORT, must listen on 0.0.0.0:$PORT
ENV PORT=8080
EXPOSE 8080

# Run WAR using embedded Tomcat (if using spring-boot-starter-tomcat)
ENTRYPOINT ["java", "-Dserver.port=$PORT", "-jar", "/app/app.war"]
