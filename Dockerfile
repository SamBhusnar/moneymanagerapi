# ---------- Stage 1: Build the Spring Boot application ----------
FROM maven:3.9.6-amazoncorretto-21 AS build

# Set working directory inside the container
WORKDIR /app

# Copy pom.xml and download dependencies (cached layer)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy the entire project and build it
COPY . .
RUN mvn clean package -DskipTests

# ---------- Stage 2: Run the application ----------
FROM amazoncorretto:21
WORKDIR /app

# Copy the built jar from the previous stage
COPY --from=build /app/target/*.jar moneymanager-v1.0.jar

# Expose the app port (make sure same as in your Spring Boot config)
EXPOSE 9090

# Run the application
ENTRYPOINT ["java", "-jar", "moneymanager-v1.0.jar"]
