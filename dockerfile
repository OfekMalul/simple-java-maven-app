FROM maven:3.9 as builder

ARG APP_VERSION=1.0.0

WORKDIR /app

COPY . .

# Clean removes all dependencies from previous build.
# Install compiles the code + test and install dependencies
RUN mvn clean install -DskipTests

FROM openjdk:11-jre

WORKDIR /app
# copies the executable from previous stage to current stage
COPY --from=builder /app/target/my-app-*.jar ./app.jar

# execute the jar file app.jar
CMD ["java", "-jar", "./app.jar"]