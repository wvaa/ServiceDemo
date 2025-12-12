pipeline {
    agent any

    stages {
        stage('Limpieza de Contenedores') {
            steps {
                // Eliminamos el contenedor previo para liberar el puerto 8081
                sh 'docker rm -f service-demo-app || true'
            }
        }

        stage('Checkout') {
            steps {
                // Clonamos el repositorio (asegurando rama main)
                git branch: 'main', url: 'https://github.com/wvaa/ServiceDemo.git'
            }
        }

        stage('Build & Deploy (Spring Boot Java 21)') {
            steps {
                script {
                    // Creamos el Dockerfile dinámico usando Java 21
                    sh """
                    echo '# Etapa 1: Compilación' > Dockerfile.springboot
                    echo 'FROM maven:3.9.6-eclipse-temurin-21 AS build' >> Dockerfile.springboot
                    echo 'COPY . /app' >> Dockerfile.springboot
                    echo 'WORKDIR /app' >> Dockerfile.springboot
                    echo 'RUN mvn clean package -DskipTests' >> Dockerfile.springboot
                    echo '' >> Dockerfile.springboot
                    echo '# Etapa 2: Ejecución' >> Dockerfile.springboot
                    echo 'FROM eclipse-temurin:21-jre' >> Dockerfile.springboot
                    echo 'COPY --from=build /app/target/*.jar app.jar' >> Dockerfile.springboot
                    echo 'EXPOSE 8080' >> Dockerfile.springboot
                    echo 'ENTRYPOINT ["java", "-jar", "/app.jar"]' >> Dockerfile.springboot

                    # Construimos la imagen
                    docker build -t service-demo-java21 -f Dockerfile.springboot .
                    """

                    // Ejecutamos vinculando el puerto 8081 de tu Windows al 8080 del contenedor
                    sh 'docker run -d --name service-demo-app -p 8081:8080 service-demo-java21'
                }
            }
        }
    }
}