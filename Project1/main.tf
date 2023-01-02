# Terraform Project
# Amazon Web Services
# Build Apache WebServers 

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web_server" {
  ami                    = "ami-0b5eea76982371e91" # Amazon Linux 2 
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_server.id]
  user_data              = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
MYIP=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h2>WebServer with PrivateIP: $MYVIP</h2><br>Built by Terraform" > /var/www/html/index.html
service httpd start
chkconfig httpd on
EOF
  tags = {
    Name  = "Apache WebServer Terraform"
    Owner = "Jeffrey"
  }
}

resource "aws_security_group" "web_server" {
  name        = "WebServer-SG"
  description = "Security Group for my WebServer"

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
    Name  = "WebServer SG using Terraform"
    Owner = "Jeffrey"
  }
}