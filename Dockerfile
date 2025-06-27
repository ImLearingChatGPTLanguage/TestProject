# Giai đoạn 1: Build ứng dụng bằng Maven để tạo ra file .war
FROM maven:3.8.5-openjdk-11 AS build

# Sao chép toàn bộ mã nguồn vào trong image
WORKDIR /app
COPY . .

# Chạy lệnh Maven để build project và tạo file .war
RUN mvn clean package -DskipTests

# Giai đoạn 2: Chạy ứng dụng trên máy chủ Tomcat
FROM tomcat:9.0-jdk11-corretto-al2

# Xóa thư mục webapps mặc định của Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# Sao chép file .war từ giai đoạn 1 vào thư mục webapps của Tomcat
# Đổi tên thành ROOT.war để ứng dụng chạy ở đường dẫn gốc
COPY --from=build /app/target/FoodOrderingSystem.war /usr/local/tomcat/webapps/ROOT.war

# Tomcat sẽ chạy trên cổng 8080
EXPOSE 8080

# Lệnh để khởi động Tomcat khi container chạy
CMD ["catalina.sh", "run"]
