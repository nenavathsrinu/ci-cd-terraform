  terraform {
  backend "s3" {
    bucket         = "lsg-terraform-tf-state-bucket"
    key            = "ansible-ec2/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

