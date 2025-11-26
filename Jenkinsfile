pipeline {
    agent any
    tools {
        maven 'Maven-3.9.11' 
    }
    environment {
        // --- CONFIGURATION ---
        // Your Docker Hub Username
        DOCKER_HUB_USER = 'pkelotra' 
        
        // Your Roll Number
        REPO_NAME = 'imt2023563' 
        
        // The ID we created in Jenkins Credentials
        REGISTRY_CRED = 'dockerhub-login'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build & Test') {
            steps {
                echo 'Running Maven Build and Tests...'
                // This runs the JUnit tests we wrote. 
                // If tests fail, the pipeline stops here.
                bat 'mvn clean test'
            }
        }

       stage('Docker Build & Push') {
            steps {
                script {
                    echo 'Tests passed. Building Docker Image...'
                    
                    // We use this wrapper to securely inject your credentials
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-login', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        
                        // 1. Login to Docker Hub
                        // We use %VAR% to access the password securely in Windows
                        bat 'docker login -u %DOCKER_USER% -p %DOCKER_PASS%'
                        
                        // 2. Build the image
                        bat "docker build -t ${env.DOCKER_HUB_USER}/${env.REPO_NAME}:${env.BUILD_ID} ."
                        
                        // 3. Push the specific version
                        bat "docker push ${env.DOCKER_HUB_USER}/${env.REPO_NAME}:${env.BUILD_ID}"
                        
                        // 4. Tag and Push 'latest'
                        bat "docker tag ${env.DOCKER_HUB_USER}/${env.REPO_NAME}:${env.BUILD_ID} ${env.DOCKER_HUB_USER}/${env.REPO_NAME}:latest"
                        bat "docker push ${env.DOCKER_HUB_USER}/${env.REPO_NAME}:latest"
                    }
                }
            }
        }
    }
}
