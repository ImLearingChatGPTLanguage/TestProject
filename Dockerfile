# Giai đoạn 1: Build ứng dụng bằng Maven để tạo ra file .war
FROM maven:3.8.5-openjdk-11 AS build

# Tạo thư mục làm việc
WORKDIR /app

# Sao chép file pom.xml trước để tận dụng cache của Docker
COPY FoodOrderingSystem/pom.xml .

# Tải các dependency trước
RUN mvn dependency:go-offline

# Sao chép toàn bộ mã nguồn của project vào
COPY FoodOrderingSystem/ .

# Chạy lệnh Maven để build project
RUN mvn clean package -DskipTests


# Giai đoạn 2: Chạy ứng dụng trên máy chủ Tomcat
FROM tomcat:9.0-jdk11-corretto-al2

# Xóa thư mục webapps mặc định
RUN rm -rf /usr/local/tomcat/webapps/*

# Sao chép file .war đã build vào thư mục webapps của Tomcat
# Đổi tên thành ROOT.war để ứng dụng chạy ở đường dẫn gốc
COPY --from=build /app/target/FoodOrderingSystem.war /usr/local/tomcat/webapps/ROOT.war

# Tomcat sẽ chạy trên cổng 8080
EXPOSE 8080

# Lệnh để khởi động Tomcat
CMD ["catalina.sh", "run"]
