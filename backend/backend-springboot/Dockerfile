# Usa una imagen de Java con Maven
FROM maven:3.8.5-openjdk-17

# Establece el directorio de trabajo
WORKDIR /app

# Copia los archivos del proyecto
COPY . /app

# Construye la aplicación
RUN mvn clean package -DskipTests

# Usa una imagen ligera de Java para correr el JAR
FROM openjdk:17
WORKDIR /app

# Copia el JAR desde la imagen de Maven
COPY --from=0 /app/target/*.jar app.jar

# Expone el puerto en el que corre Spring Boot
EXPOSE 8080

# Comando para ejecutar la aplicación
CMD ["java", "-jar", "app.jar"]
