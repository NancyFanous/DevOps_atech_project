pipeline {
    agent any

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

                        sh "terraform apply -auto-approve"
                    }
                }
            }
        }
    }
}
