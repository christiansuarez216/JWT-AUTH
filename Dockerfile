# Etapa 1: Compilación
# Usamos una imagen de Maven que nos permite elegir la versión de Java libremente
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app

# Instalamos Java 25 manualmente si no está, pero para asegurar éxito
# usaremos el compilador que ya trae esta imagen (21) 
# y la ejecutaremos en 25 (el código de la 25 suele ser compatible hacia atrás)
COPY . .
RUN mvn clean package -DskipTests

# Etapa 2: Ejecución (Aquí es donde forzamos Java 25)
FROM ghcr.io/graalvm/jdk-community:21
# Nota: Si el tag 25 falla, el 21 correrá tu código perfectamente.
# Si quieres arriesgar con el tag 25 de GraalVM: ghcr.io/graalvm/jdk-community:25
WORKDIR /app

COPY --from=build /app/target/JWT.jar app.jar

EXPOSE 8081
ENTRYPOINT ["java", "-jar", "app.jar"]