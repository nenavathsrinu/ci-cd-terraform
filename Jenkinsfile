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
          sh 'terraform apply -var-file="dev.tfvars" -auto-approve'
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
        sshagent (credentials: ['ansible-ssh-key']) {
          sh '''
            ssh -o StrictHostKeyChecking=no ec2-user@13.234.112.80 '
              ansible-playbook -i /home/ec2-user/ansible-playbooks/inventory.ini \
              /home/ec2-user/ansible-playbooks/install_httpd.yml \
              --private-key /home/ec2-user/ansible-playbooks/ansible.pem'
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
  }
}
