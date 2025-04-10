#!/usr/bin/env groovy

library identifier: 'my-aws-maven-SL@main', retriever: modernSCM(
    [$class: 'GitSCMSource',
    remote: 'https://github.com/raouf21-dev/my-aws-maven-SL.git',
    credentialsID: 'git-creds'
    ]
)

pipeline {
    agent any
    tools {
        maven 'maven-3.9.9'
    }
    environment {
        IMAGE_NAME = 'santana20095/java-maven:1.0'
    }
    stages {
        stage('build app') {
            steps {
                echo 'building application jar...'
                buildJar()
            }
        }
        stage('build image') {
            steps {
                script {
                    echo 'building the docker image...'
                    buildImage(env.IMAGE_NAME)
                    dockerLogin()
                    dockerPush(env.IMAGE_NAME)
                }
            }
        } 
        stage("deploy") {
            steps {
                script {
                    echo 'deploying docker image to EC2...'
                    sshagent(['ec2-server-key']) {
                        sh "scp docker-compose.yaml ec2-user@13.39.146.56"
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@13.39.146.56 "
                        sh 
                    }
                }
            }               
        }
        stage('Check target contents') {
            steps {
                sh 'ls -l target/'
            }
        }
    }
}