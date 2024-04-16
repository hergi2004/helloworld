# Use the official Maven image to create a build artifact.
# https://hub.docker.com/_/maven
FROM maven:3.6.3-jdk-11-slim AS build
COPY src /home/app/src
COPY pom.xml /home/app
RUN mvn -f /home/app/pom.xml clean package

# For the production stage, use the official Java runtime.
# https://hub.docker.com/_/openjdk
FROM openjdk:11-jre-slim
COPY --from=build /home/app/target/helloworld-1.0.0.jar /usr/local/lib/helloworld.jar
EXPOSE 8081
ENTRYPOINT ["java","-jar","/usr/local/lib/helloworld.jar"]
