FROM maven:3.9 as builder

WORKDIR /app

COPY . .

# Clean removes all dependencies from previous build.
# Install compiles the code + test and install dependencies
RUN mvn clean install

FROM openjdk:11-jre

WORKDIR /app
# copies the executable from previous stage to current stage
COPY --from=builder /app/target/my-app-1.0-SNAPSHOT.jar ./app.jar

# execute the jar file app.jar
CMD ["java", "-jar", "./app.jar"]