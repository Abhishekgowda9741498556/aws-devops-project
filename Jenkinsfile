pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "yourdockerhubusername/yourapp"
        DOCKER_CREDENTIALS_ID = "dockerhub-creds"
        SONARQUBE_SERVER = "SonarQube"
        SONARQUBE_TOKEN = credentials('sonarqube-token')
        NEXUS_CREDENTIALS_ID = "nexus-creds"
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/Abhishekgowda9741498556/aws-cicd-pipeline-project.git'
            }
        }

        stage('SonarQube Code Quality') {
            steps {
                withSonarQubeEnv("${SONARQUBE_SERVER}") {
                    sh 'mvn clean verify sonar:sonar -Dsonar.login=$SONARQUBE_TOKEN'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t $DOCKER_IMAGE:$BUILD_NUMBER ."
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDENTIALS_ID}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh """
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                        docker push $DOCKER_IMAGE:$BUILD_NUMBER
                    """
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh """
                    helm upgrade --install myapp ./helm-chart/my-app \
                    --set image.repository=$DOCKER_IMAGE \
                    --set image.tag=$BUILD_NUMBER
                """
            }
        }
    }

    post {
        always {
            echo "Cleaning up..."
            sh "docker system prune -f"
        }
    }
}
