pipeline {
    agent any
    tools {
        maven 'maven'
    }
    stages {

        stage("cleanup workspace") {
           steps { 
           cleanWs()
           }
        }

        stage("checkout SCM") {
           steps { 
           git branch: 'main', poll: false, url: 'https://github.com/ramkumar95/project'
           }
        }

        stage("build") {
           steps { 
           sh 'mvn clean package -e'
           }
        }
    }
}
