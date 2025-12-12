pipeline {
    agent any

    stages {
        stage('Limpieza') {
            steps {
                sh 'docker rm -f service-demo-app || true'
            }
        }

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/wvaa/ServiceDemo.git'
            }
        }

        stage('Build & Deploy') {
            steps {
                script {
                    sh """
                    echo 'FROM maven:3.9.6-eclipse-temurin-21 AS build' > Dockerfile.springboot
                    echo 'WORKDIR /app' >> Dockerfile.springboot
                    echo 'COPY . .' >> Dockerfile.springboot

                    # Intentamos compilar. Si falla el repackage, Maven nos dirá por qué.
                    echo 'RUN mvn clean package -DskipTests' >> Dockerfile.springboot

                    echo 'FROM eclipse-temurin:21-jre' >> Dockerfile.springboot
                    echo 'WORKDIR /app' >> Dockerfile.springboot

                    # Copiamos el archivo JAR generado (Spring Boot lo nombra por el <artifactId> en el pom.xml)
                    echo 'COPY --from=build /app/target/*.jar app.jar' >> Dockerfile.springboot
                    echo 'EXPOSE 8080' >> Dockerfile.springboot

                    # Usamos el comando estándar. Java leerá automáticamente la Main-Class del manifiesto del JAR.
                    echo 'ENTRYPOINT ["java", "-jar", "app.jar"]' >> Dockerfile.springboot

                    docker build -t service-demo-java21 -f Dockerfile.springboot .
                    """

                    sh 'docker run -d --name service-demo-app -p 8081:8080 service-demo-java21'
                }
            }
        }
    }
}