// Jenkinsfile para la Integración Continua de ServiceDemo con DinD
pipeline {
    // === 1. Configuración del Agente DinD Efímero ===
    agent {
        // Le pedimos a Jenkins que lance un contenedor temporal como agente
        docker {
            image 'docker:dind'
            // Permiso necesario para que el daemon interno de Docker funcione
            args '--privileged'
            // Definimos el label para el agente
            //label 'dind-builder'
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
                    // Espera activa de 15 segundos para que el daemon interno inicie
                    sh 'timeout 15 sh -c "while ! docker info > /dev/null 2>&1; do echo Waiting for DinD daemon...; sleep 1; done"'
                    echo '¡Daemon DinD interno listo para usar!'

                    // Verificamos que no hay imágenes ni contenedores preexistentes en este daemon aislado
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

                    // Ejecuta el contenedor. Asumimos que la aplicación expone el puerto 80.
                    // Esto simula un despliegue de prueba en el entorno aislado.
                    sh "docker run -d --name ${containerName} -p 8080:80 ${imageTag}"

                    // Verificación (opcional): Espera y verifica los logs del contenedor
                    echo 'Esperando unos segundos y mostrando los logs del contenedor...'
                    sh "sleep 5"
                    sh "docker logs ${containerName}"

                    // Mostrar los contenedores activos en el daemon DinD
                    sh "docker ps"

                    // Detener y eliminar el contenedor de prueba (limpieza interna)
                    sh "docker stop ${containerName}"
                    sh "docker rm ${containerName}"
                }
            }
        }
    }

    // El 'post' se ejecuta después de que todas las etapas terminan (éxito o fallo)
    post {
        always {
            // Este comando es opcional pero bueno para forzar la limpieza del DinD
            // Aunque el agente efímero se destruye, forzar la eliminación de imágenes es buena práctica.
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