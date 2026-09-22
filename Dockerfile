# =============================================================================
# REPOSITORIO UNIVERSITARIO UPLA - ARQUITECTURA DE SOFTWARE
# Autor / Estudiante: Alessander (Ingeniería de Sistemas - UPLA)
# Multi-Stage Dockerfile para Tomcat 9 y despliegue automático en Render
# =============================================================================

# --- ETAPA 1: Compilación con Maven ---
FROM maven:3.8.7-openjdk-11-slim AS build
WORKDIR /app

# Copiar configuración de dependencias y código fuente
COPY pom.xml .
COPY src ./src

# Compilar el proyecto empaquetando a WAR sin correr tests
RUN mvn clean package -DskipTests

# --- ETAPA 2: Ejecución con Apache Tomcat 9 ---
FROM tomcat:9.0-jdk11-openjdk-slim

# Limpiar las aplicaciones por defecto de Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# Copiar el archivo WAR generado desde la etapa de compilación como ROOT.war
COPY --from=build /app/target/ROOT.war /usr/local/tomcat/webapps/ROOT.war

# Exponer el puerto predeterminado de HTTP en Tomcat
EXPOSE 8080

# Iniciar Tomcat
CMD ["catalina.sh", "run"]
