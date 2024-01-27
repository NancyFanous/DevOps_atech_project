pipeline {
    agent any

    environment {
        ECR_URL = '933060838752.dkr.ecr.us-east-1.amazonaws.com'
        IMAGE_NAME = 'polybot_nancyf'
        DOCKERFILE_PATH = 'polybot/Dockerfile'
        POLYBOT_DEPLOYMENT_FILE = 'k8s/polybot.yaml'
        GITHUB_REPO_URL = 'https://github.com/NancyFanous/DevOps_atech_project.git'
        GIT_CREDENTIALS_ID = 'git-pass-credentials-ID'
        GIT_BRANCH = 'main'  // Update this if your default branch is different
    }

    stages {
        stage('Checkout') {
            steps {
                withCredentials([usernamePassword(credentialsId: GIT_CREDENTIALS_ID, passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                    script {
                        checkout([
                            $class: 'GitSCM',
                            branches: [[name: "*/${GIT_BRANCH}"]],
                            doGenerateSubmoduleConfigurations: false,
                            extensions: [],
                            submoduleCfg: [],
                            userRemoteConfigs: [
                                [credentialsId: GIT_CREDENTIALS_ID, url: GITHUB_REPO_URL]
                            ]
                        ])
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
                    withCredentials([usernamePassword(credentialsId: GIT_CREDENTIALS_ID, passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                        sh """
                        aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ECR_URL
                        docker build -t $IMAGE_NAME:$BUILD_NUMBER -f $DOCKERFILE_PATH .
                        docker tag $IMAGE_NAME:$BUILD_NUMBER $ECR_URL/$IMAGE_NAME:$BUILD_NUMBER
                        docker push $ECR_URL/$IMAGE_NAME:$BUILD_NUMBER

                        sed -i "s|image: .*|image: $ECR_URL/$IMAGE_NAME:$BUILD_NUMBER|" $POLYBOT_DEPLOYMENT_FILE

                        git add $POLYBOT_DEPLOYMENT_FILE
                        git commit -m "Update container image version in Kubernetes deployment"
                        git tag -a some_tag -m 'Jenkins'
                        git push https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/NancyFanous/DevOps_atech_project.git --tags
                        """
                    }
                }
            }
        }
    }
}
