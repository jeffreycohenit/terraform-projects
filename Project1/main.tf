resource "aws_instance" "app_server" {
  ami           = "ami-830c94e3" #Amazon Linux 2 
  instance_type = "t2.micro"
  vpc_security_group_ids = ["aws_security_group.web.id]
  user_data = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
MYIP=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h2>WebServer with PrivateIP: $MYVIP 
service httpd start
chkconfig httpd on
EOF
  tags = {
    Name  = "WebServer Built using terraform"
    Owner = "Jeffrey"
  }
}

resource "aws_security_group" "web" {
  name        = "WebServer-SG"
  description = "Security Group for my WebServer"

  ingress {
    description = "Allow HTTP Port"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_block = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow All Ports"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  tags = {
    Name  = "WebServer SG using Terraform"
    Owner = "Jeffrey"
  }
}