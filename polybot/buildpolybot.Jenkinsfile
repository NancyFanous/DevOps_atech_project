pipeline {
    agent any

    environment {
        ECR_URL = '933060838752.dkr.ecr.us-east-1.amazonaws.com'
        IMAGE_NAME = 'polybot_nancyf'
        DOCKERFILE_PATH = 'polybot/Dockerfile'
        POLYBOT_DEPLOYMENT_FILE = 'k8s/polybot.yaml'
        GIT_BRANCH = 'main'
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    checkout scm
                    sh 'git checkout -B main'
                }
            }
        }

        stage('Build') {
            when {
                changeset "polybot/**"
            }
            steps {
                withCredentials([usernamePassword(credentialsId: 'github_jenkins', passwordVariable: 'GITHUB_PASSWORD', usernameVariable: 'GITHUB_USERNAME')]) {
                    script {
                        sh """
                        aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ECR_URL
                        docker build -t $IMAGE_NAME:$BUILD_NUMBER -f $DOCKERFILE_PATH .
                        docker tag $IMAGE_NAME:$BUILD_NUMBER $ECR_URL/$IMAGE_NAME:$BUILD_NUMBER
                        docker push $ECR_URL/$IMAGE_NAME:$BUILD_NUMBER

                        sed -i "s|image: .*|image: $ECR_URL/$IMAGE_NAME:$BUILD_NUMBER|" $POLYBOT_DEPLOYMENT_FILE

                        git add $POLYBOT_DEPLOYMENT_FILE
                        git commit -m "Update container image version in Kubernetes deployment"

                        git push origin main
                        """
                    }
                }
            }
        }
    }
}
