# Use Maven to build the war file
FROM maven:3.9.6-eclipse-temurin-11 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Run the app on Tomcat 10 (Jakarta EE 10 support)
FROM tomcat:10.1-jdk11
# Enable Tomcat to read environment variables (like PORT) directly in server.xml
RUN echo 'org.apache.tomcat.util.digester.PROPERTY_SOURCE=org.apache.tomcat.util.digester.EnvironmentPropertySource' >> conf/catalina.properties

# Replace default server.xml with our custom one to bind to Railway's $PORT
COPY server.xml /usr/local/tomcat/conf/server.xml

# Clear the default webapps and copy our deployed WAR as ROOT.war so it serves at "/"
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /app/target/EmcCalculatorExtended-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war

CMD ["catalina.sh", "run"]
