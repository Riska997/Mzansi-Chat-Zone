# Build the existing Jakarta EE WAR with Java 17.
FROM maven:3.9.11-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn -B -q dependency:go-offline
COPY src ./src
RUN mvn -B -q -DskipTests package

# Payara Micro 6 supports Jakarta EE 10 (Servlets, JSP and WebSockets).
FROM payara/micro:6.2025.11-jdk17
COPY --from=build /app/target/chat.war /opt/payara/deployments/chat.war
EXPOSE 8080
CMD ["--deploy", "/opt/payara/deployments/chat.war", "--contextroot", "ROOT", "--noHazelcast"]
