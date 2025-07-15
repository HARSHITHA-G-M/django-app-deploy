pipeline {
    agent any

    environment {
        IMAGE_NAME = "bharadh548/django-blog:${BUILD_NUMBER}"
    }

    stages {
        stage('Clone') {
            steps {
                git 'https://github.com/HARSHITHA-G-M/django-app-deploy.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t $IMAGE_NAME ."
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh "echo Bharadhrk@123 | docker login -u bharadh548 --password-stdin"
                    sh "docker push $IMAGE_NAME"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh "sed -i 's|image: .*|image: $IMAGE_NAME|' k8s-deploy.yaml"
                sh 'kubectl apply --validate=false -f k8s-deploy.yaml'

            }
        }
    }
}

