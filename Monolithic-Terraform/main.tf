# Terraform Project
# Amazon Web Services
# Build Apache WebServers 

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# First EC2 instance
resource "aws_instance" "web_server_1" {
  ami                    = "ami-0b5eea76982371e91" # Amazon Linux 2 
  instance_type          = "t2.micro"
  availability_zone      = "us-east-1a"
  vpc_security_group_ids = [aws_security_group.web_server_sg.id]
  user_data              = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
systemctl start httpd
systemctl enable httpd
echo "<h2>Apache Web Server 1</h2>" > /var/www/html/index.html
EOF
  tags = {
    Name  = "1st Apache Web Server Terraform"
    Owner = "Jeffrey"
  }
}

# Second EC2 instance
resource "aws_instance" "web_server_2" {
  ami                    = "ami-0b5eea76982371e91" # Amazon Linux 2 
  instance_type          = "t2.micro"
  availability_zone      = "us-east-1b"
  vpc_security_group_ids = [aws_security_group.web_server_sg.id]
  user_data              = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
systemctl start httpd
systemctl enable httpd
echo "<h2>Apache Web Server 2</h2>" > /var/www/html/index.html
EOF
  tags = {
    Name  = "2nd Apache Web Server Terraform"
    Owner = "Jeffrey"
  }
}

# Third EC2 instance
resource "aws_instance" "web_server_3" {
  ami                    = "ami-0b5eea76982371e91" # Amazon Linux 2 
  instance_type          = "t2.micro"
  availability_zone      = "us-east-1c"
  vpc_security_group_ids = [aws_security_group.web_server_sg.id]
  user_data              = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
systemctl start httpd
systemctl enable httpd
echo "<h2>Apache Web Server 3</h2>" > /var/www/html/index.html
EOF
  tags = {
    Name  = "3rd Apache Web Server Terraform"
    Owner = "Jeffrey"
  }
}

resource "aws_security_group" "web_server_sg" {
  name        = "WebServer-SG"
  description = "Security Group for my Apache Web Server"

  ingress {
    description = "Allow access on SSH Port"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow access on HTTP Port"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow access on All Ports"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "Apache Web Server SG"
    Owner = "Jeffrey"
  }
}