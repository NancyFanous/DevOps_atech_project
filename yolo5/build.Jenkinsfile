pipeline {
    agent any

    environment {
        ECR_URL = '933060838752.dkr.ecr.us-east-1.amazonaws.com'
        IMAGE_NAME = 'yolo5_nancyf'
        DOCKERFILE_PATH = 'yolo5/Dockerfile'
        YOLO5_DEPLOYMENT_FILE = 'k8s/yolo5.yaml'
        GITHUB_REPO_URL = 'https://github.com/NancyFanous/DevOps_atech_project.git'
        GITHUB_CREDENTIALS = 'github_jenkins'
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    def repoDirectory = "${workspace}/DevOps_atech_project"

                    dir(repoDirectory) {
                        checkout([$class: 'GitSCM',
                            branches: [[name: 'main']],
                            doGenerateSubmoduleConfigurations: false,
                            extensions: [[$class: 'CloneOption', noTags: false, shallow: true, depth: 1, reference: '', honorRefspec: false]],
                            submoduleCfg: [],
                            userRemoteConfigs: [[url: 'https://github.com/NancyFanous/DevOps_atech_project.git', credentialsId: 'github_jenkins']]])
                    }
                }
            }
        }

        stage('Build') {
            when {

                changeset "yolo5/**"
            }

            steps {
                script {
                    def repoDirectory = "${workspace}/DevOps_atech_project"

                    dir(repoDirectory) {
                        withCredentials([usernamePassword(credentialsId: 'github_jenkins', passwordVariable: 'GITHUB_PASSWORD', usernameVariable: 'GITHUB_USERNAME')]) {
                            sh """
                            aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ECR_URL
                            docker build -t $IMAGE_NAME:$BUILD_NUMBER -f $DOCKERFILE_PATH .
                            docker tag $IMAGE_NAME:$BUILD_NUMBER $ECR_URL/$IMAGE_NAME:$BUILD_NUMBER
                            docker push $ECR_URL/$IMAGE_NAME:$BUILD_NUMBER

                            git checkout releseas
                            git fetch origin releseas
                            git reset --hard origin/releseas

                            sed -i "s%image: .*%image: $ECR_URL/$IMAGE_NAME:$BUILD_NUMBER%g" $YOLO5_DEPLOYMENT_FILE
                            git remote set-url origin https://${GITHUB_USERNAME}:${GITHUB_PASSWORD}@github.com/NancyFanous/DevOps_atech_project.git

                            git add $YOLO5_DEPLOYMENT_FILE
                            git commit -m "Update container image version in Kubernetes deployment"
                            git pull origin releseas
                            git push origin releseas
                            """
                        }
                    }
                }
            }
        }
    }
}
