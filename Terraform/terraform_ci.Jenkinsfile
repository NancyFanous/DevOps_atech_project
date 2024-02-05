pipeline {
    agent any

    environment {
        TF_HOME = tool 'Terraform'
        AWS_DEFAULT_REGION = 'eu-north-1'
        TELEGRAM_TOKEN_CREDENTIALS_ID = 'telegram_token'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init & Apply') {
            steps {
                script {
                    // Retrieve Telegram token from Jenkins secret text credentials
                    def telegramToken = credentials(
                        TELEGRAM_TOKEN_CREDENTIALS_ID
                    )

                    // Change the working directory to the Terraform directory
                    dir('/Terraform') {
                        // Run Terraform init
                        sh "terraform init"

                        // Run Terraform apply with required variables
                        sh "terraform apply -auto-approve -var 'telegram_token=${telegramToken}'"
                    }
                }
            }
        }
    }
}
