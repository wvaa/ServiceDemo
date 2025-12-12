pipeline {
    agent {
        docker {
            image 'docker:dind'
            // IMPORTANTE: Unimos el agente a la red del host para que vea el puerto 2375 de Windows
            args '--privileged --network host'
        }
    }

    environment {
        SERVICE_NAME = 'servicedemo-app'
        // Le decimos a Jenkins Master que hable con Windows via TCP
        DOCKER_HOST = 'tcp://host.docker.internal:2375'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/wvaa/ServiceDemo.git'
            }
        }

        stage('Initialize DinD') {
            steps {
                script {
                    // DENTRO del agente DinD, debemos borrar la variable DOCKER_HOST
                    // para que use su propio socket interno y no el de Windows.
                    withEnv(['DOCKER_HOST=unix:///var/run/docker.sock']) {
                        echo 'Esperando al daemon DinD interno...'
                        sh 'timeout 15 sh -c "while ! docker info > /dev/null 2>&1; do sleep 1; done"'
                        echo '¡DinD aislado listo!'
                        sh 'docker info'
                    }
                }
            }
        }

        stage('Build Image') {
            steps {
                script {
                    // Forzamos el uso del socket interno para la construcción
                    withEnv(['DOCKER_HOST=unix:///var/run/docker.sock']) {
                        sh "docker build -t ${env.SERVICE_NAME}:${env.BUILD_ID} ."
                    }
                }
            }
        }

        // ... (Otras etapas de Run Test Container siguiendo el mismo patrón withEnv)
    }

    post {
        always {
            script {
                // En el post, volvemos a usar TCP para limpiar (si fuera necesario) en el host
                sh "docker images -q | xargs -r docker rmi || true"
            }
        }
    }
}