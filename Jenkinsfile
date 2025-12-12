pipeline {
    agent any

    stages {
        stage('Limpieza') {
            steps {
                // Detenemos el contenedor anterior si existe
                sh 'docker rm -f service-demo-app || true'
            }
        }

        stage('Checkout') {
            steps {
                // Forzamos el uso de la rama main
                git branch: 'main', url: 'https://github.com/wvaa/ServiceDemo.git'
            }
        }

        stage('Build & Deploy (Spring Boot)') {
            steps {
                script {
                    // Creamos un Dockerfile para compilar y ejecutar Java
                    sh """
                    echo '# Etapa 1: Compilación con Maven' > Dockerfile.springboot
                    echo 'FROM maven:3.8.5-openjdk-17-slim AS build' >> Dockerfile.springboot
                    echo 'COPY . /app' >> Dockerfile.springboot
                    echo 'WORKDIR /app' >> Dockerfile.springboot
                    echo 'RUN mvn clean package -DskipTests' >> Dockerfile.springboot
                    echo '' >> Dockerfile.springboot
                    echo '# Etapa 2: Ejecución con JRE' >> Dockerfile.springboot
                    echo 'FROM openjdk:17-jdk-slim' >> Dockerfile.springboot
                    echo 'COPY --from=build /app/target/*.jar app.jar' >> Dockerfile.springboot
                    echo 'EXPOSE 8080' >> Dockerfile.springboot
                    echo 'ENTRYPOINT ["java", "-jar", "/app.jar"]' >> Dockerfile.springboot

                    docker build -t service-demo-image -f Dockerfile.springboot .
                    """

                    // Ejecutamos el contenedor mapeando el puerto 8080 de Spring al 8081 de Windows
                    sh 'docker run -d --name service-demo-app -p 8081:8080 service-demo-image'
                }
            }
        }
    }
}