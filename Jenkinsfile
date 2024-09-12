pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = "harshunishu/nishu-cicd:${BUILD_NUMBER}"
        SCANNER_HOME= tool 'sonar-scanner'
    }

    stages {
       
        stage('GetCode') {
            steps {
                git branch: 'main', url: 'https://github.com/Nisarga2608/swiggy-nodejs-devops-project.git'
            }
        }
        
        stage('Build') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker', toolName: 'Docker') {
                        sh "docker build -t ${DOCKER_IMAGE} ."
                    }
                }
            }
        }
        
        stage ("SonarQube") {
            steps {
                withSonarQubeEnv('sonar-install') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Campground \
                    -Dsonar.projectKey=Campground '''
                }
            }
        }
        
        stage('Push') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker', toolName: 'Docker') {
                        sh "docker push ${DOCKER_IMAGE}"
                    }
                }
            }
        }
        
        stage('container') {
            steps {
                sh "docker run -itd --name harshu3 -p 3004:3000 ${DOCKER_IMAGE}" 
            }
        }
    }
}
