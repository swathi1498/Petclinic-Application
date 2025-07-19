FROM openjdk:21-jdk-slim
WORKDIR /app
COPY spring-petclinic-3.5.0-SNAPSHOT.jar app.jar
CMD ["java", "-jar", "app.jar"]
