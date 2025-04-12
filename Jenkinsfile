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
    // environment {
    //     IMAGE_NAME = 'santana20095/java-maven:1.0'
    // }
    stages {
        stage('Increment version'){
            steps{
                script{
                    echo "Incrementing app version..."
                    sh "mvn build-helper:parse-version versions:set \
                    -DnewVersion=\\\${parsedVersion.majorVersion}.\\\${parsedVersion.nextMinorVersion}.\\\${parsedVersion.nextIncrementalVersion} versions:commit"
                    def matcher = readFile("pom.xml") =~ "<version>(.+)</version>"
                    def version = matcher[0][1]
                    env.IMAGE_NAME = "santana20095/java-maven:${version}-${BUILD_NUMBER}"
                }
            }
        }
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
                def shellCmd = "bash ./server-cmds.sh ${IMAGE_NAME}"
                    def ec2Instance = "ec2-user@13.39.146.56"
                    def pwd = "/home/ec2-user"
                    sshagent(['ec2-server-key']) {
                        sh "scp server-cmds.sh ${ec2Instance}:${pwd}"
                        sh "scp docker-compose.yaml ${ec2Instance}:${pwd}"
                        sh "ssh -o StrictHostKeyChecking=no ${ec2Instance} ${shellCmd}"                        
                    }
                }
            }               
        }
        stage('commit version update') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'git-creds', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                    sh "git remote set-url origin https://$USER:$PASS@github.com/raouf21-dev/maven-app.git"
                    sh "git add ."
                    sh 'git commit -m "ci: version bump"'
                    sh "git push origin HEAD:jenkins-jobs" 
                }
            }
        }
    }
}