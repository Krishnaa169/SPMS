# ==============================================================================
# Multi-stage Dockerfile for Student Project Management System (SPMS) on Render
# ==============================================================================

# Stage 1: Build the application with Maven & OpenJDK 17
FROM maven:3.9.6-eclipse-temurin-17 AS builder
WORKDIR /app

# Copy pom.xml and source code
COPY pom.xml .
COPY src ./src

# Package WAR and exploded webapp
RUN mvn clean package -DskipTests

# Stage 2: Minimal runtime image
FROM eclipse-temurin:17-jre
WORKDIR /app

# Copy compiled classes, exploded web application, and resources
COPY --from=builder /app/target/classes ./target/classes
COPY --from=builder /app/target/SPMS ./target/SPMS
COPY --from=builder /app/src/main/webapp ./src/main/webapp

# Create directories for embedded Tomcat workdir and uploaded documents
RUN mkdir -p target/tomcat-embed uploads

# Render automatically sets PORT environment variable (defaults to 8080)
ENV PORT=8080
EXPOSE 8080

# Run SPMS embedded server optimized for cloud memory constraints
CMD ["sh", "-c", "java -XX:MaxRAMPercentage=75.0 -Xss512k -cp 'target/classes:target/SPMS/WEB-INF/lib/*' com.spms.Main"]
