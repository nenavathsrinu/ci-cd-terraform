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
              echo "⚠️ Terraform apply exited unexpectedly: ${err}"
              error("Stopping pipeline due to Terraform failure")
            }
          }
        }
      }
    }

    stage('Wait for EC2 to boot') {
      steps {
        script {
          echo '⏳ Waiting for EC2 instance to become ready...'
          sleep(time: 60, unit: 'SECONDS')
        }
      }
    }

    stage('Run Ansible on Remote Server') {
      steps {
        sshagent (credentials: ['ansible']) {
          sh '''
            mkdir -p ~/.ssh && touch ~/.ssh/known_hosts
            ssh -o StrictHostKeyChecking=no ec2-user@13.232.198.57 "ansible-playbook -i /home/ec2-user/ansible-playbooks/inventory.ini /home/ec2-user/ansible-playbooks/install_httpd.yml --private-key /home/ec2-user/ansible-playbooks/client.pem"
          '''
        }
      }
    }
  }

  post {
    success {
      echo '✅ Pipeline completed successfully!'
    }
    failure {
      echo '❌ Pipeline failed. Check console output.'
    }
    always {
      echo '🧹 Cleaning up pipeline state'
    }
  }
}
