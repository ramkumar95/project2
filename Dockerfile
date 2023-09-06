FROM maven:3.9.0-eclipse-temurin-17 as build
WORKDIR /app
COPY . .
RUN mvn clean install


FROM ubuntu:latest
RUN apt update 
RUN apt install tomcat9 -y
RUN chown -R tomcat:tomcat /usr/share/tomcat9/
RUN mkdir  /usr/share/tomcat9/logs
WORKDIR /var/lib/tomcat9/webapps/
COPY --from=build /app/target/maven_web.war .
EXPOSE 8080
WORKDIR /usr/share/tomcat9/bin
CMD ["./catalina.sh", "start"]
