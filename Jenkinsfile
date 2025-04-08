#!/usr/bin.env groovy

pipeline {   
    agent any
    stages {
        stage("test") {
            steps {
                script {
                    echo "Testing the application..."

                }
            }
        }
        stage("build") {
            steps {
                script {
                    echo "Building the application..."
                }
            }
        }

        stage("deploy") {
            steps {
                script {    
                    def dockerRemoveImage = "docker rmi santana20095/java-maven:1.0"
                    def dockerPullImage = "docker pull santana20095/java-maven:1.0"
                    def dockerCmd = "docker run -p 3080:3080 -d santana20095/java-maven:1.0"
                    def updatEC2 = "sudo yum update -y"
                    sshagent(['ec2-server-key']) {
                       sh "ssh -o StrictHostKeyChecking=no ec2-user@13.39.146.56 ${dockerPullImage}"
                       sh "ssh -o StrictHostKeyChecking=no ec2-user@13.39.146.56 ${dockerCmd}"
                    }
                }
            }
        }               
    }
} 
