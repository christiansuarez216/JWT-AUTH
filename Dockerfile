# Etapa 1: Compilación
FROM maven:3.9.9-eclipse-temurin-25 AS build
WORKDIR /JWT
COPY . .
RUN mvn clean package -DskipTests

# Etapa 2: Ejecución
FROM eclipse-temurin:25-jre
WORKDIR /JWT
COPY --from=build /app/target/JWT.jar JWT.jar
EXPOSE 8081
ENTRYPOINT ["java", "-jar", "JWT.jar"]