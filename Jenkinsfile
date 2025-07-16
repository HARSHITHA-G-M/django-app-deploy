pipeline {
    agent any

    environment {
        IMAGE_NAME = "bharadh548/django-blog:latest"
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')   // Docker Hub creds ID in Jenkins
    }

    stages {
        stage('Clean Workspace') {
            steps {
                deleteDir()
            }
        }

        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM',
                    branches: [[name: '*/master']],
                    userRemoteConfigs: [[url: 'https://github.com/HARSHITHA-G-M/django-app-deploy.git']]
                ])
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME} ."
            }
        }

        stage('Login to Docker Hub') {
            steps {
                sh "echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin"
            }
        }

        stage('Push Docker Image') {
            steps {
                sh "docker push ${IMAGE_NAME}"
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                // Use your kubeconfig secret file stored in Jenkins as 'kubeconfig'
                withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
                    sh '''
                        # Update the image in the k8s yaml without --record (deprecated)
                        kubectl set image -f k8s-deploy.yaml django-container=${IMAGE_NAME} --kubeconfig=$KUBECONFIG
                        
                        # Apply the updated deployment
                        kubectl apply -f k8s-deploy.yaml --kubeconfig=$KUBECONFIG
                    '''
                }
            }
        }
    }
}

