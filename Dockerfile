# Etapa 1: Compilación usando Java 25 directamente
FROM eclipse-temurin:25-jdk AS build
WORKDIR /JWT

# Instalamos Maven manualmente dentro de la imagen de Java 25
RUN apt-get update && apt-get install -y maven

COPY . .
RUN mvn clean package -DskipTests

# Etapa 2: Ejecución
FROM eclipse-temurin:25-jre
WORKDIR /JWT
COPY --from=build /app/target/JWT.jar JWT.jar
EXPOSE 8081
ENTRYPOINT ["java", "-jar", "JWT.jar"]