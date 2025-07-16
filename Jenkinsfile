pipeline {
    agent any

    environment {
        IMAGE_NAME = "bharadh548/django-blog:latest"
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
    }

    stages {
        stage('Clean Workspace') {
            steps {
                deleteDir()
            }
        }

        stage('Checkout') {
            steps {
                git url: 'https://github.com/HARSHITHA-G-M/django-app-deploy.git', branch: 'master'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${IMAGE_NAME} ."
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                script {
                    sh "echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin"
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    sh "docker push ${IMAGE_NAME}"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh "kubectl set image -f k8s-deploy.yaml django-container=${IMAGE_NAME} --record"
                    sh "kubectl apply -f k8s-deploy.yaml"
                }
            }
        }
    }
}

