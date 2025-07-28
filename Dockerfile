FROM eclipse-temurin:17-jdk-alpine AS builder
WORKDIR /application
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
COPY src src
RUN ./mvnw package -DskipTests
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} application.jar
RUN java -Djarmode=layertools -jar application.jar extract


FROM eclipse-temurin:17-jre-alpine
RUN apk add --no-cache curl netcat-openbsd
WORKDIR /application
COPY --from=builder /application/dependencies/ ./
COPY --from=builder /application/spring-boot-loader/ ./
COPY --from=builder /application/snapshot-dependencies/ ./
COPY --from=builder /application/application/ ./
COPY wait-for-services.sh /wait-for-services.sh
RUN chmod +x /wait-for-services.sh
ENTRYPOINT ["/wait-for-services.sh"]
