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
          sh 'terraform init'
        }
      }
    }

    stage('Terraform Apply') {
      options {
        timeout(time: 10, unit: 'MINUTES')
      }
      steps {
        withCredentials([[ 
          $class: 'AmazonWebServicesCredentialsBinding',
          credentialsId: 'aws-credentials'
        ]]) {
          script {
            try {
              sh 'terraform apply -auto-approve'
            } catch (err) {
              echo "⚠️ Terraform apply failed: ${err}"
              error("Stopping pipeline")
            }
          }
        }
      }
    }

    stage('Output Instance Info') {
      steps {
        sh 'terraform output'
      }
    }
  }

  post {
    success {
      echo '✅ Terraform infrastructure provisioned!'
    }
    failure {
      echo '❌ Terraform provisioning failed!'
    }
  }
}
