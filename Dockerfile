# Etapa 1: Compilación
FROM openjdk:25-jdk-slim AS build
WORKDIR /app

# Instalamos Maven para procesar el proyecto
RUN apt-get update && apt-get install -y maven && rm -rf /var/lib/apt/lists/*

COPY . .
RUN mvn clean package -DskipTests

# Etapa 2: Ejecución
FROM openjdk:25-jdk-slim
WORKDIR /app

# NOTA: Aquí usamos JWT.jar porque es el nombre que definiste en tu pom.xml
COPY --from=build /app/target/JWT.jar app.jar

EXPOSE 8081
# Ejecutamos la aplicación
ENTRYPOINT ["java", "-jar", "app.jar"]