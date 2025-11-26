pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "pkelotra/imt2023563:latest"
    }

    stages {

        stage('Checkout') {
            steps {
                echo "Pulling code from GitHub..."
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: "*/main"]],
                    userRemoteConfigs: [[
                        url: 'https://github.com/pkelotra/SE_CICD.git',
                        credentialsId: 'github-Credentials'
                    ]]
                ])
            }
        }

        stage('Build & Test') {
            steps {
                echo "Compiling and testing Java code..."
                bat "mvn clean package"
            }
        }

        stage('Docker Login') {
            steps {
                echo "Logging in to Docker Hub..."
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub',
                    passwordVariable: 'DOCKER_PASS',
                    usernameVariable: 'DOCKER_USER'
                )]) {
                    bat """
                        echo %DOCKER_PASS% | docker login -u %DOCKER_USER% --password-stdin
                    """
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                bat "docker build -t %DOCKER_IMAGE% ."
            }
        }

        stage('Push Docker Image') {
            steps {
                echo "Pushing Docker image to Docker Hub..."
                bat "docker push %DOCKER_IMAGE%"
            }
        }

        stage('Verify Docker Image') {
            steps {
                echo "Running container to verify..."
                bat """
                    docker run --rm %DOCKER_IMAGE% java -version
                """
            }
        }
    }

    post {
        always {
            echo "Cleaning up workspace..."
            cleanWs()
        }
    }
}
