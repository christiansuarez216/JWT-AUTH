# Etapa 1: Compilación usando Java 21 (Estable y disponible)
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app

# Copiamos y compilamos
COPY . .
RUN mvn clean package -DskipTests

# Etapa 2: Ejecución
FROM eclipse-temurin:21-jre
WORKDIR /app

# Usamos tu archivo JWT.jar
COPY --from=build /app/target/JWT.jar app.jar

# Railway necesita que escuchemos en el puerto que ellos nos dan
EXPOSE 8081
ENTRYPOINT ["java", "-jar", "app.jar"]