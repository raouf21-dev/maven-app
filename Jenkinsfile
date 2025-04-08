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
                    // def dockerCmd = 'docker run -p 3080:3080 -d santana20095/aws-maven-app:1.0'
                    def updatEC2 = "yum update -y"
                    sshagent(['ec2-server-key']) {
                       sh "ssh -o StrictHostKeyChecking=no ec2-user@13.39.146.56 ${updatEC2}"
                    }
                }
            }
        }               
    }
} 
