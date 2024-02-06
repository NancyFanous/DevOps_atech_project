pipeline {
    agent any
    environment {
        TELEGRAM_TOKEN = credentials('telegram_token')
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    checkout scm
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {

                    dir('Terraform') {

                        sh "terraform init -upgrade"
                        sh "terraform apply -auto-approve -var=\"telegram_token=${env.TELEGRAM_TOKEN}\""
                    }
                }
            }
        }
    }
}
