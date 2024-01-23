pipeline {
    agent any

    parameters {
        string(name: 'POLYBOT_IMAGE_BUILD_NUM', defaultValue: '', description: 'Polybot Image Build Number')
    }

    environment {
        HELM_CHART_DIR = 'polybot_chart'
    }

    stages {
        stage('Deploy') {
            steps {
                script {
                    sh """
                    helm upgrade --install polybot-${params.POLYBOT_IMAGE_BUILD_NUM} $HELM_CHART_DIR --set image.tag=${params.POLYBOT_IMAGE_BUILD_NUM}
                    """
                }
            }
        }
    }
}
