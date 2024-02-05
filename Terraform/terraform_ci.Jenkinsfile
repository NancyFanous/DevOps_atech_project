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

                    // Run Terraform init and apply using the Terraform plugin
                    terraformCLI(
                        commands: "init",
                        workingDirectory: "/"
                    )

                    terraformCLI(
                        commands: "apply -auto-approve -var 'telegram_token=${telegramToken}'",
                        workingDirectory: "/"
                    )
                }
            }
        }
    }
}
