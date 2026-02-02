# Etapa 1: Construcción
FROM ubuntu:22.04 AS build

# Instalar dependencias necesarias (wget para descargar Java, maven para compilar)
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    maven \
    && rm -rf /var/lib/apt/lists/*

# Descargar e instalar JDK 25 (OpenJDK oficial)
# Usamos el enlace directo del binario de Linux x64
RUN wget https://download.java.net/java/early_access/jdk25/11/GPL/openjdk-25-ea+11_linux-x64_bin.tar.gz && \
    tar -xvf openjdk-25-ea+11_linux-x64_bin.tar.gz && \
    mv jdk-25 /opt/jdk-25

# Configurar variables de entorno para que el sistema use Java 25
ENV JAVA_HOME=/opt/jdk-25
ENV PATH="$JAVA_HOME/bin:$PATH"

WORKDIR /JWT
COPY . .

# Compilar el proyecto
RUN mvn clean package -DskipTests

# Etapa 2: Ejecución
FROM ubuntu:22.04
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*

# Copiamos el JDK 25 desde la etapa anterior para que sea ligero
COPY --from=build /opt/jdk-25 /opt/jdk-25
ENV JAVA_HOME=/opt/jdk-25
ENV PATH="$JAVA_HOME/bin:$PATH"

WORKDIR /JWT
COPY --from=build /app/target/JWT.jar JWT.jar

EXPOSE 8081
ENTRYPOINT ["java", "-jar", "JWT.jar"]