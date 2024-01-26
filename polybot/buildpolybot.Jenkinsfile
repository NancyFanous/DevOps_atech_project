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
                withCredentials([usernamePassword(credentialsId: 'github_jenkins', usernameVariable: 'GITHUB_USERNAME', passwordVariable: 'GITHUB_TOKEN')]) {
                    script {
                        sh "git config credential.helper '!f() { sleep 1; echo username=\$1; echo password=\$2; }; f'"
                        sh "git config --global user.email 'jenkins@yourcompany.com'"
                        sh "git config --global user.name 'Jenkins'"
                        sh "git config --global push.default simple"
                        sh "git config --global pull.default simple"

                        sh "git remote set-url origin https://$GITHUB_USERNAME:$GITHUB_TOKEN@github.com/NancyFanous/DevOps_atech_project.git"
                        checkout scm
                    }
                }
            }
        }

        stage('Build') {
            when {
                changeset "polybot/**"
            }
            steps {
                script {
                    sh """
                    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ECR_URL &&
                    docker build -t $IMAGE_NAME:$BUILD_NUMBER -f $DOCKERFILE_PATH . &&
                    docker tag $IMAGE_NAME:$BUILD_NUMBER $ECR_URL/$IMAGE_NAME:$BUILD_NUMBER &&
                    docker push $ECR_URL/$IMAGE_NAME:$BUILD_NUMBER &&
                    sed -i "s|image: .*|image: $ECR_URL/$IMAGE_NAME:$BUILD_NUMBER|" $POLYBOT_DEPLOYMENT_FILE &&
                    git add $POLYBOT_DEPLOYMENT_FILE &&
                    git commit -m "Update container image version in Kubernetes deployment" &&
                    git push -u origin main
                    """
                }
            }
        }
    }
}
