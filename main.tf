provider "aws" {
  region = var.aws_region
}

# Create key pair from local public key file
resource "aws_key_pair" "ansible_key" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

# Security group allowing SSH access
resource "aws_security_group" "ansible_sg" {
  name        = "ansible-sg"
  description = "Allow SSH access"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # -1 means all protocols
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ansible-sg"
  }
}

# EC2 instance for Ansible with user_data script
resource "aws_instance" "ansible_server" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  key_name                    = aws_key_pair.ansible_key.key_name
  vpc_security_group_ids      = [aws_security_group.ansible_sg.id]

  associate_public_ip_address = true  # Optional: if you're using a public subnet

  user_data = file("${path.module}/install_ansible.sh")

  tags = {
    Name = "ansible-server"
  }
}

