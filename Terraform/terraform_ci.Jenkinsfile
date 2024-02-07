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
            when {
                changeset "Terraform/**"
            }
            steps {
                script {
                    dir('Terraform') {
                        sh "terraform init"
                        sh "terraform apply -auto-approve -var=\"telegram_token=${env.TELEGRAM_TOKEN}\""
                    }
                }
            }
        }
    }
}
