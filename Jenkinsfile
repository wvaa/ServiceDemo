pipeline {
    agent any

    stages {
        stage('Limpieza inicial') {
            steps {
                // Borra archivos de construcciones anteriores
                deleteDir()
                // Limpia el contenedor si existe
                sh 'docker rm -f apache-service || true'
            }
        }

        stage('Checkout') {
            steps {
                // Especificamos la rama 'main'
                git branch: 'main', url: 'https://github.com/wvaa/ServiceDemo.git'
            }
        }

        stage('Build & Deploy Apache') {
            steps {
                script {
                    sh """
                    echo 'FROM httpd:2.4-alpine' > Dockerfile.deploy
                    echo 'COPY . /usr/local/apache2/htdocs/' >> Dockerfile.deploy
                    docker build -t service-demo-image -f Dockerfile.deploy .
                    """

                    // Desplegamos mapeando el puerto 8081 del host
                    sh 'docker run -d --name apache-service -p 8081:80 service-demo-image'
                }
            }
        }
    }
}