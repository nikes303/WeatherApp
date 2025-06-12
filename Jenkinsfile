pipeline {
    agent any

    tools {
        jdk 'jdk21'
    }

    environment {
        SCANNER_HOME = tool 'Sonar-scanner'
    }

    stages {
        stage('Git checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/nikes303/WeatherApp.git'
            }
        }

        stage('Sonarqube Analysis') {
            steps {
                bat """
                ${SCANNER_HOME}/bin/Sonar-Scanner ^
                -Dsonar.projectName=weather ^
                -Dsonar.host.url=http://localhost:9000 ^
                -Dsonar.token=squ_f077b9c88ae86e11a59b6dfc21625668950f4aee ^
                -Dsonar.java.binaries=. ^
                -Dsonar.projectKey=weatherkey
                """
            }
        }

        stage('OWASP Dependency Check') {
            steps {
                dependencyCheck additionalArguments: '-scan .', odcInstallation: 'DP'
                dependencyCheckPublisher pattern: 'dependency-check-report.xml'
            }
        }

        stage("Docker Build & Push"){
            steps{
                script{
                    withDockerRegistry(credentialsId: 'docker') {
                        bat "docker build -f Dockerfile -t weather ."
                        bat "docker tag weather:latest nikes303/weather:latest"
                        bat "docker push nikes303/weather:latest"
                    }
                }
            }
        }
        stage('Trivy Docker Scan'){
            steps{
                bat "trivy image nikes303/weather:latest"
            }
        }
        stage("Docker deploy (on Agent)") {
    steps {
        script {
            withDockerRegistry(credentialsId: 'docker') {
                // Map host port 4000 to container port 80
                bat "docker run -d --name weather -p 4000:80 nikes303/weather:latest"
            }
        }
    }
}

    }
    post {
        always {
            echo 'Pipeline finished.'
        }
    }

}
