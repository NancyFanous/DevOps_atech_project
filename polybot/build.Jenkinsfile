pipeline {
    agent any

    environment {
        ECR_URL = '933060838752.dkr.ecr.us-east-1.amazonaws.com'
        IMAGE_NAME = 'polybot_nancyf'
        DOCKERFILE_PATH = 'polybot/Dockerfile'
        POLYBOT_DEPLOYMENT_FILE = 'k8s/polybot.yaml'
        GITHUB_REPO_URL = 'https://github.com/NancyFanous/DevOps_atech_project.git'
        GITHUB_CREDENTIALS = 'github_jenkins'
        GIT_BRANCH = 'main'
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    checkout([$class: 'GitSCM',
                              branches: [[name: 'main']],
                              doGenerateSubmoduleConfigurations: false,
                              extensions: [[$class: 'CloneOption', noTags: false, shallow: true, depth: 1, reference: '', honorRefspec: false]],
                              submoduleCfg: [],
                              userRemoteConfigs: [[url: GITHUB_REPO_URL, credentialsId: GITHUB_CREDENTIALS]]])
                }
            }
        }

        stage('Build') {
            steps {
                script {
                    sh """
                    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ECR_URL
                    docker build -t $IMAGE_NAME:$BUILD_NUMBER -f $DOCKERFILE_PATH .
                    docker tag $IMAGE_NAME:$BUILD_NUMBER $ECR_URL/$IMAGE_NAME:$BUILD_NUMBER
                    docker push $ECR_URL/$IMAGE_NAME:$BUILD_NUMBER

                    sed -i "s|image: .*|image: $ECR_URL/$IMAGE_NAME:$BUILD_NUMBER|" $POLYBOT_DEPLOYMENT_FILE
                    git remote set-url origin $GITHUB_REPO_URL
                    git add $POLYBOT_DEPLOYMENT_FILE
                    git commit -m "Update container image version in Kubernetes deployment"
                    GIT_ASKPASS=echo git push origin $GIT_BRANCH
                    """
                }
            }
        }
    }
}
