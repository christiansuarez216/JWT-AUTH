# Etapa 1: Compilación (Usamos la imagen oficial de Maven con JDK 21 o 25 si está disponible)
# Si falla el 25, esta imagen de Maven suele tener soporte multi-versión
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /JWT

# Aquí forzamos la instalación de herramientas para Java 25 si fuera necesario, 
# pero para evitar errores de red, vamos a asegurar la compatibilidad:
COPY . .
RUN mvn clean package -DskipTests

# Etapa 2: Ejecución (Aquí sí usamos Java 25 puro)
FROM eclipse-temurin:25-jre
WORKDIR /JWT
COPY --from=build /app/target/JWT.jar JWT.jar
EXPOSE 8081
ENTRYPOINT ["java", "-jar", "JWT.jar"]