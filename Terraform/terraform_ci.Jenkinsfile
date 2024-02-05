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

        stage('Terraform Init') {
            steps {
                dir('Terraform') {
                    script {
                        // Run Terraform init
                        sh "terraform init"
                    }
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('Terraform') {
                    script {
                        // Retrieve Telegram token from Jenkins secret text credentials
                        def telegramToken = credentials(TELEGRAM_TOKEN_CREDENTIALS_ID)

                        // Run Terraform plan and capture the output
                        def terraformPlanOutput = sh(script: "terraform plan -input=false -var 'telegram_token=${telegramToken}'", returnStdout: true).trim()

                        // Check if there are changes in the plan
                        if (terraformPlanOutput.contains("No changes.")) {
                            echo "No changes in Terraform plan. Skipping Terraform apply."
                        } else {
                            echo "Changes detected in Terraform plan. Proceeding with Terraform apply."
                            currentBuild.result = 'FAILURE' // Set result to FAILURE if changes are detected

                            // Optionally, notify or take actions based on the changes
                            // e.g., send a notification to a Slack channel or trigger another job

                            // Run Terraform apply with auto-approve and variable
                            sh "terraform apply -auto-approve -var 'telegram_token=${telegramToken}'"
                        }
                    }
                }
            }
        }
    }
}
