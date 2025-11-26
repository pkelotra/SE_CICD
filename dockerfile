# ---------------------------
# Stage 1: Build with Maven
# ---------------------------
FROM maven:3.9-eclipse-temurin-21-alpine AS builder

WORKDIR /app

COPY pom.xml .
RUN mvn -q -e -DskipTests dependency:resolve

COPY src ./src
RUN mvn clean package -DskipTests

# ---------------------------
# Stage 2: Run the JAR
# ---------------------------
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

COPY --from=builder /app/target/todo-list-1.0-SNAPSHOT.jar app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]
