pipeline {
  agent any

  stages {
    stage('Checkout Code') {
      steps {
        git credentialsId: 'github-creds', url: 'https://github.com/nenavathsrinu/ci-cd-terraform.git', branch: 'main'
      }
    }

    stage('Terraform Init') {
      steps {
        sh 'terraform init'
      }
    }

    stage('Terraform Apply') {
      steps {
        sh 'terraform apply -auto-approve'
      }
    }
  }
}
