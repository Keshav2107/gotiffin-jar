FROM eclipse-temurin:21-jdk-alpine
WORKDIR /app
VOLUME /tmp
COPY build/libs/gotiffin-1.0.0.jar app.jar
ENTRYPOINT ["java","-jar","/app/app.jar"]
