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
                    deployImage()
                }
            }               
        }
        stage('commit version update') {
            steps {
                script{
                    echo "commiting the version update..."
                    commitVersionUpdate()
                }
            }
        }
    }
}