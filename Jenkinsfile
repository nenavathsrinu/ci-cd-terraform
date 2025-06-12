pipeline {
  agent any

  environment {
    AWS_DEFAULT_REGION = 'ap-south-1'
  }

  stages {
    stage('Checkout Code') {
      steps {
        git credentialsId: 'github-creds', url: 'https://github.com/nenavathsrinu/ci-cd-terraform.git', branch: 'main'
      }
    }

    stage('Terraform Init') {
      steps {
        withCredentials([[ 
          $class: 'AmazonWebServicesCredentialsBinding', 
          credentialsId: 'aws-credentials' 
        ]]) {
          script {
            def status = sh(script: 'terraform init', returnStatus: true)
            if (status != 0) {
              error('❌ Terraform Init Failed. Check backend config or credentials.')
            }
          }
        }
      }
    }

    stage('Terraform Apply') {
      options {
        timeout(time: 10, unit: 'MINUTES') // Prevent infinite hanging
      }
      steps {
        withCredentials([[ 
          $class: 'AmazonWebServicesCredentialsBinding', 
          credentialsId: 'aws-credentials' 
        ]]) {
          script {
            def status = sh(script: 'terraform apply -auto-approve', returnStatus: true)
            if (status != 0) {
              error('❌ Terraform Apply Failed. Please check logs.')
            }
          }
        }
      }
    }
  }
}

