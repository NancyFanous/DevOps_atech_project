pipeline {
    agent any

    environment{
        ECR_URL = '933060838752.dkr.ecr.us-east-1.amazonaws.com'
        IMAGE_NAME = 'polybot_nancyf'
        DOCKERFILE_PATH = '/polybot'
    }
    stages {
        stage('Build') {
            steps {
                sh '''
                aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ECR_URL
                docker build -t $IMAGE_NAME:$BUILD_NUMBER -f $DOCKERFILE_PATH .
                docker tag $IMAGE_NAME:$BUILD_NUMBER $ECR_URL/$IMAGE_NAME:$BUILD_NUMBER
                docker push $ECR_URL/$IMAGE_NAME:$BUILD_NUMBER
                '''
            }
        }
    }
}