pipeline {
    agent any

    environment {
        TF_HOME = tool 'Terraform'
        AWS_DEFAULT_REGION = 'eu-north-1'
        TERRAFORM_DIR = '/terraform'
        TELEGRAM_TOKEN_CREDENTIALS_ID = 'telegram_token'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    dir(TERRAFORM_DIR) {
                        sh "${TF_HOME}/terraform init"
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {

                    def telegramToken = credentials(
                        TELEGRAM_TOKEN_CREDENTIALS_ID
                    )

                    dir(TERRAFORM_DIR) {
                        sh "${TF_HOME}/terraform apply -auto-approve \
                            -var 'telegram_token=${telegramToken}'"
                    }
                }
            }
        }
    }
}
