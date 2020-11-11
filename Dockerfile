FROM maven:3.6-jdk-11 as builder

# Copy local code to the container image.
WORKDIR /tmp
COPY pom.xml .
COPY src ./src

# Build a release artifact.
RUN mvn package -DskipTests

FROM openjdk:15-jdk-slim-buster as packager
WORKDIR /tmp
COPY --from=builder /tmp/target/demo-0.0.1-SNAPSHOT.jar /tmp/application.jar
RUN java -Djarmode=layertools -jar application.jar extract

FROM openjdk:15-jdk-slim-buster

WORKDIR /app
COPY --from=packager /tmp/dependencies/ ./
COPY --from=packager /tmp/snapshot-dependencies/ ./
COPY --from=packager /tmp/spring-boot-loader/ ./
COPY --from=packager /tmp/application/ ./

ENTRYPOINT ["java", "org.springframework.boot.loader.JarLauncher"]
