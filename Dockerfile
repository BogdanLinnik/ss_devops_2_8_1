# Use official Maven image with JDK 11 for building the application
FROM maven:3.9.5-eclipse-temurin-11 AS build

# Set working directory for the build
WORKDIR /app

# Copy project files
COPY . .

# Build the application
RUN mvn clean
RUN mvn test
RUN mvn package -Dmaven.test.skip

# Use official Tomcat image for running the application
FROM tomcat:9.0-jdk11

# Set working directory for Tomcat
WORKDIR /usr/local/tomcat

# Copy the built WAR file to the Tomcat webapps directory
COPY --from=build /app/target/ROOT.war ./webapps/

# Expose the default Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
