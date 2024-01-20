pipeline {
    agent any

    environment {
        ECR_URL = '933060838752.dkr.ecr.us-east-1.amazonaws.com'
        IMAGE_NAME = 'polybot_nancyf'
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    checkout scm
                }
            }
        }

        stage('Build') {
            steps {
                script {
                    sh "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ECR_URL"
                    sh "docker build -t $IMAGE_NAME:17 -f polybot/Dockerfile ."
                    sh "docker tag $IMAGE_NAME:17 $ECR_URL/$IMAGE_NAME:17"
                    sh "docker push $ECR_URL/$IMAGE_NAME:17"
                }
            }
        }
    }
}
