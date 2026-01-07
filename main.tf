provider "aws" {
  region = var.aws_region
}

# Use existing VPC
data "aws_vpc" "existing" {
  id = var.vpc_id
}

# Use existing public subnet
data "aws_subnet" "public" {
  id = var.public_subnet_id
}

# Security Group in the existing VPC
resource "aws_security_group" "demo_sg" {
  name        = "hcp-terraform-demo-sg"
  description = "Allow SSH"
  vpc_id      = data.aws_vpc.existing.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "demo_ec2" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.demo_sg.id]
  associate_public_ip_address = true

  tags = {
    Name  = "hcp-terraform-demo"
    Owner = "terraform-demo"
  }
}
