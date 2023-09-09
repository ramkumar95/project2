FROM maven:3.9.0-eclipse-temurin-17 as build
WORKDIR /app
COPY . .
RUN mvn clean install

FROM tomcat
WORKDIR webapps/
COPY --from=build /app/target/maven_web.war .
