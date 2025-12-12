pipeline {
    agent any

    stages {
        stage('Preparar Entorno') {
            steps {
                // Limpia contenedores e imágenes viejas para evitar conflictos de puertos
                sh 'docker rm -f apache-service || true'
            }
        }

        stage('Checkout') {
            steps {
                git 'https://github.com/wvaa/ServiceDemo.git'
            }
        }

        stage('Build & Deploy Apache') {
            steps {
                script {
                    // Creamos un Dockerfile dinámico que usa Apache y copia el contenido del repo
                    sh """
                    echo 'FROM httpd:2.4-alpine' > Dockerfile.deploy
                    echo 'COPY . /usr/local/apache2/htdocs/' >> Dockerfile.deploy
                    docker build -t service-demo-image -f Dockerfile.deploy .
                    """

                    // Desplegamos en el puerto 8081
                    sh 'docker run -d --name apache-service -p 8081:80 service-demo-image'
                }
            }
        }
    }
}