provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "demo_ec2" {
  ami           = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name = "hcp-terraform-demo"
    Owner = "demo"
  }
}
