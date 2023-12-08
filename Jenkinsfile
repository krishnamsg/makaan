pipeline {
    agent any
    tools {
        jdk "Java17"
        maven "Maven3"
    }
    environment {
        string(name: 'BRANCH_NAME', defaultValue: 'main', description: 'Enter the branch name')
        APP_NAME = "complete-production-e2e-makaan-pipeline"
        RELEASE = "1.0.0"
        DOCKER_USER = "krishnamsg"
        DOCKER_PASS = 'dockerhub'
        IMAGE_NAME = "${DOCKER_USER}" + "/" + "${APP_NAME}"
        IMAGE_TAG = "${RELEASE}-${BUILD_NUMBER}"
        JENKINS_API_TOKEN = credentials("JENKINS_API_TOKEN")
      }
    stages{
        stage('Cleanup Workspace') {
            steps {
                cleanWs()
            }
        }
    stages {
        stage('Checkout') {
            steps {
                script {
                    // Checkout the code from GitHub based on the specified branch
                    checkout([$class: 'GitSCM', branches: [[name: params.BRANCH_NAME]], userRemoteConfigs: [[url: 'https://github.com/krishnamsg/makaan.git']]])
                }
            }
        }
                stage('Build Application') {
            steps {
                sh "mvn clean install"
            }
        }
        stage('Test Application') {
            steps {
                sh 'mvn test'
            }
        }
/*        stage('SonarQube Analysis') {
            steps {
                script{
                    withSonarQubeEnv(credentialsId: 'jenkins-sonarqube-token') {
                        sh 'mvn sonar:sonar'
                    }
                }
            }
      }
*/
        stage("Build & Push Docker Image") {
            steps {
                script {
                    docker.withRegistry('',DOCKER_PASS) {
                        docker_image = docker.build "${IMAGE_NAME}"
                    }

                    docker.withRegistry('',DOCKER_PASS) {
                        docker_image.push("${IMAGE_TAG}")
                        docker_image.push('latest')
                    }
                }
            }

        }
         stage("Trigger CD Pipeline") {
            steps {
                script {
                    sh "curl -v -k --user sagar:${JENKINS_API_TOKEN} -X POST -H 'cache-control: no-cache' -H 'content-type: application/x-www-form-urlencoded' --data 'IMAGE_TAG=${IMAGE_TAG}' 'http://10.0.0.100:8080/job/makan_kubernetes/buildWithParameters?token=gitops-token'"
                }
            }

        }

    }
}
