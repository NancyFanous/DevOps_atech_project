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
                dir('Terraform') {
                    script {
                        // Retrieve Telegram token from Jenkins secret text credentials
                        def telegramToken = credentials(
                            TELEGRAM_TOKEN_CREDENTIALS_ID
                        )

                        // Run Terraform init
                        sh "terraform init"

                        // Run Terraform apply with auto-approve and variable
                        sh "terraform apply -auto-approve -var 'telegram_token=${telegramToken}'"
                    }
                }
            }
        }
    }
}
