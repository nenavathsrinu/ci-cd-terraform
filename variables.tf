variable "aws_region" {
  default = "ap-south-1"
}

variable "ami_id" {
  type        = string
  description = "AMI ID to use"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  type        = string
  description = "Name of the SSH key pair"
}

variable "public_key_path" {
  type        = string
  description = "Path to your public SSH key"
}

variable "private_key_path" {
  type        = string
  description = "Path to your private SSH key"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID for EC2 instance"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where EC2 will be launched"
}

variable "allowed_cidr_blocks" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}
variable "tags" {
  type        = map(string)
  description = "Tags to apply to the EC2 instance"
  default     = {
    Name        = "ansible-ec2-instance"
    Environment = "dev"
  }
}
