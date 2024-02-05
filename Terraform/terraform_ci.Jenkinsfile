pipeline {
    agent any

    environment {
        TF_CLI_ARGS = "-input=false"
        TF_IN_AUTOMATION = "true"
        TELEGRAM_TOKEN_CREDENTIALS_ID = 'telegram_token'

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
                       def telegramToken = TELEGRAM_TOKEN_CREDENTIALS_ID

                        sh "terraform apply -auto-approve -var 'telegram_token=${telegramToken}'"
                    }
                }
            }
        }
    }
}
