pipeline {
    // Ejecutamos el pipeline base en el Master para tener acceso a Git
    agent any

    environment {
        SERVICE_NAME = 'servicedemo-app'
    }

    stages {
        stage('Checkout Code') {
            steps {
                // El checkout se hace en el Master, que tiene Git instalado
                git branch: 'main', url: 'https://github.com/wvaa/ServiceDemo.git'
            }
        }

        stage('Build & Test in DinD') {
            // Solo esta etapa usará el contenedor DinD
            agent {
                docker {
                    image 'docker:dind'
                    args '--privileged'
                }
            }
            steps {
                script {
                    // 1. Esperar al daemon interno
                    sh 'timeout 15 sh -c "while ! docker info > /dev/null 2>&1; do echo Waiting...; sleep 1; done"'

                    // 2. Construir la imagen
                    // Nota: Al estar dentro del bloque agent docker, Jenkins intenta
                    // mapear el workspace automáticamente.
                    sh "docker build -t ${SERVICE_NAME}:${env.BUILD_ID} ."

                    // 3. Prueba rápida
                    sh "docker run --rm ${SERVICE_NAME}:${env.BUILD_ID} echo 'Contenedor funcionando'"
                }
            }
        }
    }
}