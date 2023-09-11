pipeline {
    agent any
    tools {
        maven 'maven'
    }
    environment {
     APP_NAME = "jenkins"
     RELEASE = "1.0"
     DOCKER_USER = "rambpm"
     DOCKER_PASS = "dockerhub_auth"
     IMAGE_NAME = "${DOCKER_USER}" + "/" + "${APP_NAME}"
     IMAGE_TAG = "${RELEASE}-${BUILD_NUMBER}"
     JENKINS_API_TOKEN = credentials("jenkins_token")
    }
    stages {

        stage("cleanup workspace") {
           steps { 
           cleanWs()
           }
        }

        stage("checkout SCM") {
           steps { 
           git branch: 'main', poll: false, url: 'https://github.com/ramkumar95/project2.git'
           }
        }

        stage("build") {
           steps { 
           sh 'mvn clean package -e'
           }
        }

        stage("quality test analysis") {
           steps { 
             script{
              withSonarQubeEnv(credentialsId: 'sonarqube') {
              sh "mvn sonar:sonar"
             }
           }
           }
        }
       
        stage("quality gate") {
           steps { 
            script { 
           waitForQualityGate abortPipeline: false, credentialsId: 'sonarqube'
           }
           }
        }

         stage("docker image") {
           steps { 
            script { 
             withDockerRegistry(credentialsId: 'dockerhub_auth') {
             docker_image = docker.build "${IMAGE_NAME}"
           }
             withDockerRegistry(credentialsId: 'dockerhub_auth'){
             docker_image.push("${IMAGE_TAG}")
             }
           }
           }
        }

              stage("trivy scan") {
           steps { 
            script { 
             sh 'trivy image rambpm/jenkins:"${IMAGE_TAG}" --no-progress --scanners vuln  --exit-code 0 --severity HIGH,CRITICAL --format table'
           }
           }
        }

            stage("cleanup") {
              steps { 
                script { 
                  sh 'docker rmi rambpm/jenkins:"${IMAGE_TAG}"'
                  sh 'docker rmi rambpm/jenkins:latest'
           }
           }
        }
            stage("invoking cd pipeline") {
              steps { 
               build job: 'cd-pipeline', parameters: [[$class: 'StringParameterValue', name: 'IMAGE_TAG', value: '${IMAGE_TAG}']]
           }
        }

    }
}
