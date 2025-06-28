# Giai đoạn 1: Build ứng dụng bằng Maven
FROM maven:3.8.5-openjdk-11 AS build

WORKDIR /app
COPY FoodOrderingSystem/pom.xml .
RUN mvn dependency:go-offline
COPY FoodOrderingSystem/ .
RUN mvn clean package -DskipTests

# Giai đoạn 2: Chạy ứng dụng trên máy chủ Tomcat
FROM tomcat:9.0-jdk11-corretto-al2

# Xóa nội dung webapps mặc định
RUN rm -rf /usr/local/tomcat/webapps/*

# Sao chép file .war đã build vào
COPY --from=build /app/target/FoodOrderingSystem.war /usr/local/tomcat/webapps/ROOT.war

# ---- PHẦN THAY ĐỔI QUAN TRỌNG ----
# Tạo script để ghi các biến môi trường của Render vào file application.properties
# File này sẽ được đặt vào thư mục classes, nơi Spring có thể đọc được
RUN echo "db.url=${DB_URL}" > /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/application.properties && \
    echo "db.username=${DB_USERNAME}" >> /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/application.properties && \
    echo "db.password=${DB_PASSWORD}" >> /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/application.properties

EXPOSE 8080
CMD ["catalina.sh", "run"]
