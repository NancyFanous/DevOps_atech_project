pipeline {
    agent any

    environment {
        TF_HOME = tool 'Terraform'
        AWS_DEFAULT_REGION = 'eu-north-1'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('Terraform') {
                    script {
                        // Run Terraform apply
                        sh "terraform apply -auto-approve"
                    }
                }
            }
        }
    }
}
