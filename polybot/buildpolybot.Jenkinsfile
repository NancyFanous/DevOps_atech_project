pipeline {
    agent any

    environment {
        ECR_URL = '933060838752.dkr.ecr.us-east-1.amazonaws.com'
        IMAGE_NAME = 'polybot_nancyf'
        DOCKERFILE_PATH = 'polybot/Dockerfile'
        POLYBOT_DEPLOYMENT_FILE = 'k8s/polybot.yaml'
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    // Use git with SSH and disable StrictHostKeyChecking
                    GIT_SSH_COMMAND = "ssh -o StrictHostKeyChecking=no"
                    checkout([$class: 'GitSCM', branches: [[name: '*/main']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: 'git@github.com:NancyFanous/DevOps_atech_project.git']]])
                }
            }
        }

        stage('Build') {
            when {
                changeset "polybot/**"
            }
            steps {
                script {
                    // Authenticate with AWS ECR
                    sh """
                    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ECR_URL
                    docker build -t $IMAGE_NAME:$BUILD_NUMBER -f $DOCKERFILE_PATH .
                    docker tag $IMAGE_NAME:$BUILD_NUMBER $ECR_URL/$IMAGE_NAME:$BUILD_NUMBER
                    docker push $ECR_URL/$IMAGE_NAME:$BUILD_NUMBER

                    sed -i "s|image: .*|image: $ECR_URL/$IMAGE_NAME:$BUILD_NUMBER|" $POLYBOT_DEPLOYMENT_FILE

                    git add $POLYBOT_DEPLOYMENT_FILE
                    git commit -m "Update container image version in Kubernetes deployment"
                    git push origin main
                    GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=no" git push origin main
                    """
                }
            }
        }
    }
}
