# ---------- Build stage ----------
FROM eclipse-temurin:21-jdk-jammy AS build
WORKDIR /app
COPY gotiffin-1.0.0.jar app.jar
RUN java -Djarmode=layertools -jar app.jar extract

# ---------- Runtime stage ----------
FROM eclipse-temurin:21-jre-jammy AS runtime

RUN groupadd -r spring && useradd -r -g spring spring

WORKDIR /app

COPY --from=build --chown=spring:spring /app/dependencies/ ./
COPY --from=build --chown=spring:spring /app/spring-boot-loader/ ./
COPY --from=build --chown=spring:spring /app/snapshot-dependencies/ ./
COPY --from=build --chown=spring:spring /app/application/ ./

USER spring:spring


ENTRYPOINT ["sh", "-c", "java \
  -XX:MaxRAMPercentage=60.0 \
  -XX:MaxMetaspaceSize=128m \
  -Xss256k \
  -XX:+ExitOnOutOfMemoryError \
  -XX:+UseSerialGC \
  org.springframework.boot.loader.launch.JarLauncher"]