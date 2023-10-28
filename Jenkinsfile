pipeline {
  agent any
   stages {
    stage ('Build') {
      steps {
        sh '''#!/bin/bash
        python3.7 -m venv test
        source test/bin/activate
        pip install pip --upgrade
        pip install -r requirements.txt
        '''
     }
   }
    stage ('test') {
      steps {
        sh '''#!/bin/bash
        source test/bin/activate
        pip install mysqlclient
        pip install pytest
        py.test --verbose --junit-xml test-reports/results.xml
        ''' 
      }
    
      post{
        always {
          junit 'test-reports/results.xml'
        }
       
      }
    }
   
     stage('Init') {
       agent {label 'awsDeploy'}
       steps {
        withCredentials([string(credentialsId: 'AWS_ACCESS_KEY', variable: 'aws_access_key'), 
                        string(credentialsId: 'AWS_SECRET_KEY', variable: 'aws_secret_key')]) {
                            dir('initTerraform') {
                              sh 'terraform init' 
                            }
         }
    }
   }
      stage('Plan') {
        agent {label 'awsDeploy'}
       steps {
        withCredentials([string(credentialsId: 'AWS_ACCESS_KEY', variable: 'aws_access_key'), 
                        string(credentialsId: 'AWS_SECRET_KEY', variable: 'aws_secret_key')]) {
                            dir('initTerraform') {
                              sh 'terraform plan -out plan.tfplan -var="aws_access_key=$aws_access_key" -var="aws_secret_key=$aws_secret_key"' 
                            }
         }
    }
   }
      stage('Apply') {
        agent {label 'awsDeploy'}
       steps {
        withCredentials([string(credentialsId: 'AWS_ACCESS_KEY', variable: 'aws_access_key'), 
                        string(credentialsId: 'AWS_SECRET_KEY', variable: 'aws_secret_key')]) {
                            dir('initTerraform') {
                              sh 'terraform apply plan.tfplan' 
                            }
         }
    }
   }

  }
 }
