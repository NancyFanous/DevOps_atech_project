pipeline {
    agent any

    environment {
        ECR_URL = '933060838752.dkr.ecr.us-east-1.amazonaws.com'
        IMAGE_NAME = 'polybot_nancyf'
        DOCKERFILE_PATH = 'polybot/Dockerfile'
        POLYBOT_DEPLOYMENT_FILE = 'k8s/polybot.yaml'
        GITHUB_REPO_URL = 'https://github.com/NancyFanous/DevOps_atech_project.git'
        GITHUB_CREDENTIALS = credentials('jenkins_test_1')
        GIT_BRANCH = 'main'
    }

    stages {
        stage('Build') {
            when {
                changeset "polybot/**"
            }
            steps {
                script {
                    // Docker Authentication
                    sh "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ECR_URL"

                    // Docker Build and Push
                    sh """
                        docker build -t $IMAGE_NAME:$BUILD_NUMBER -f $DOCKERFILE_PATH .
                        docker tag $IMAGE_NAME:$BUILD_NUMBER $ECR_URL/$IMAGE_NAME:$BUILD_NUMBER
                        docker push $ECR_URL/$IMAGE_NAME:$BUILD_NUMBER
                    """

                    // Update Kubernetes Deployment
                    sh "sed -i 's|image: .*|image: $ECR_URL/$IMAGE_NAME:$BUILD_NUMBER|' $POLYBOT_DEPLOYMENT_FILE"

                    // Git Operations
                    checkout([$class: 'GitSCM',
                        branches: [[name: "*/${GIT_BRANCH}"]],
                        doGenerateSubmoduleConfigurations: false,
                        extensions: [],
                        submoduleCfg: [],
                        userRemoteConfigs: [[credentialsId: GITHUB_CREDENTIALS, url: GITHUB_REPO_URL]]])

                    sh "git add $POLYBOT_DEPLOYMENT_FILE"
                    sh 'git commit -m "Update container image version in Kubernetes deployment"'
                    sh "git push origin $GIT_BRANCH"
                }
            }
        }
    }
}
