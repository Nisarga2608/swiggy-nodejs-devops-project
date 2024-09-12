pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = "harshunishu/nishu-cicd:${BUILD_NUMBER}"
        OLD_IMAGE_TAG_PATTERN = "harshunishu/nishu-cicd:*"  // Pattern to match old images
        SCANNER_HOME= tool 'sonar-scanner'
    }

    stages {
        stage('Cleanup Old Docker Images') {
            steps {
                script {
                    echo "Cleaning up old Docker images..."
                    
                    def oldImages = sh(script: "docker images --format '{{.Repository}}:{{.Tag}}' | grep '${OLD_IMAGE_TAG_PATTERN}'", returnStdout: true).trim()
                    
                    if (oldImages) {
                        oldImages.split('\n').each { image ->
                            if (image != DOCKER_IMAGE) {
                                echo "Attempting to remove old image ${image}"
                                sh """
                                    if docker images -q ${image} > /dev/null 2>&1; then
                                        docker rmi -f ${image} || echo 'Failed to remove image ${image} - might be in use or other error.'
                                    else
                                        echo 'Image ${image} does not exist.'
                                    fi
                                """
                            }
                        }
                    } else {
                        echo "No old images found matching pattern ${OLD_IMAGE_TAG_PATTERN}"
                    }
                }
            }
        }
       
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
                sh "docker run -itd --name harshu6 -p 3007:3000 ${DOCKER_IMAGE}" 
            }
        }
    }
}
