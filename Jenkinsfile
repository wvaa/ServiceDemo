// Jenkinsfile para la Integración Continua de ServiceDemo con DinD
pipeline {
    // === 1. Configuración del Agente DinD Efímero ===
    agent {
        // Le pedimos a Jenkins que lance un contenedor temporal como agente
        docker {
            image 'docker:dind'
            // Permiso necesario para que el daemon interno de Docker funcione
            args '--privileged'
            // No necesitamos la variable DOCKER_HOST aquí,
            // ya que el 'docker build' usará el daemon interno de DinD.
        }
    }

    environment {
        // Definimos la variable para el nombre de la imagen
        SERVICE_NAME = 'servicedemo-app'
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo "Clonando el repositorio: ${params.GIT_URL}"
                // Parámetros del repositorio
                git branch: 'main', url: 'https://github.com/wvaa/ServiceDemo.git'
            }
        }

        stage('Initialize DinD Environment') {
            steps {
                script {
                    echo 'Esperando la inicialización del daemon de Docker interno (DinD)...'
                    // ESTE ES EL PASO CLAVE: Asegura que el daemon DinD esté listo antes de usar 'docker'
                    sh 'timeout 15 sh -c "while ! docker info > /dev/null 2>&1; do echo Waiting for DinD daemon...; sleep 1; done"'
                    echo '¡Daemon DinD interno listo para usar!'

                    // Verificación de que el cliente Docker funciona dentro de DinD
                    sh 'docker images'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def imageTag = "${env.SERVICE_NAME}:${env.BUILD_ID}"
                    echo "Construyendo la imagen: ${imageTag} dentro de DinD"

                    // Ejecuta 'docker build' contra el daemon aislado de DinD
                    sh "docker build -t ${imageTag} ."

                    echo 'Construcción exitosa. Verificando imagen...'
                    sh "docker images | grep ${env.SERVICE_NAME}"
                }
            }
        }

        stage('Run Test Container') {
            steps {
                script {
                    def imageTag = "${env.SERVICE_NAME}:${env.BUILD_ID}"
                    def containerName = "${env.SERVICE_NAME}-test-${env.BUILD_ID}"

                    echo "Lanzando contenedor de prueba ${containerName} en el entorno DinD..."

                    // El contenedor DinD es quien orquesta este nuevo contenedor
                    sh "docker run -d --name ${containerName} -p 8080:80 ${imageTag}"

                    // Verificación de logs y limpieza
                    echo 'Esperando unos segundos y mostrando los logs del contenedor...'
                    sh "sleep 5"
                    sh "docker logs ${containerName}"
                    sh "docker ps"
                    sh "docker stop ${containerName}"
                    sh "docker rm ${containerName}"
                }
            }
        }
    }

    post {
        always {
            // El agente DinD se destruye automáticamente, pero esta limpieza es una buena práctica de precaución.
            script {
                sh "docker rmi \$(docker images -q) || true"
            }
        }
        success {
            echo 'Pipeline completado exitosamente y entorno DinD limpiado.'
        }
        failure {
            echo 'Pipeline fallido. El entorno DinD ha sido limpiado.'
        }
    }
}