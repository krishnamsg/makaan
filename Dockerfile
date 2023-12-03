# Use an official Tomcat runtime as a parent image
FROM tomcat:9.0-jdk11-openjdk-slim

# Set the working directory to the Tomcat webapps directory
WORKDIR /usr/local/tomcat/webapps/

# Copy the war file into the container at the Tomcat webapps directory
COPY target/*.war .

# Expose the port that Tomcat will run on
EXPOSE 8080

# Define an environment variable
ENV CATALINA_OPTS "-Dapp.env=production"

# Start Tomcat when the container launches
CMD ["catalina.sh", "run"]
