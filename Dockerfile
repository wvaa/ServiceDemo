# 1. ETAPA DE CONSTRUCCIÓN: Usa una imagen con herramientas de construcción (Maven y JDK)
FROM maven:3.9.6-eclipse-temurin-21 AS build

# Define el directorio de trabajo
WORKDIR /app

# Copia los archivos de configuración (pom.xml) y el código fuente
COPY pom.xml .
COPY src ./src

# Construye el proyecto y genera el JAR.
# El JAR se creará en el directorio 'target'.
RUN mvn clean package -DskipTests

# 2. ETAPA DE EJECUCIÓN: Usa una imagen ligera solo con el JRE (más pequeña y segura)
FROM eclipse-temurin:21-jre-alpine

# Define el directorio de trabajo final
WORKDIR /app

# Copia el JAR compilado desde la etapa de construcción.
# ¡IMPORTANTE! Reemplaza 'ServiceDemo-0.0.1-SNAPSHOT.jar' con el nombre de tu archivo JAR final.
COPY --from=build /app/target/servicio-dummy-0.0.1-SNAPSHOT.jar /app/app.jar

# Spring Boot usa el puerto 8080 por defecto
EXPOSE 8080

# Comando para ejecutar el JAR
ENTRYPOINT ["java", "-jar", "app.jar"]
