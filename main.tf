provider "aws" {
  region = var.region
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_security_group" "mongodb_sg" {
  name        = "mongodb-sg"
  description = "Allow MongoDB traffic"

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "mongodb_instance" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = aws_key_pair.generated_key.key_name

  security_groups = [aws_security_group.mongodb_sg.name]

  user_data = <<-EOF
    #!/bin/bash

    # Update the system packages
    sudo yum update -y

    # Install MongoDB (adjust version as needed)
    sudo tee /etc/yum.repos.d/mongodb-org-4.4.repo <<EOL
    [mongodb-org-4.4]
    name=MongoDB Repository
    baseurl=https://repo.mongodb.org/yum/amazon/2/mongodb-org/4.4/x86_64/
    gpgcheck=1
    enabled=1
    gpgkey=https://www.mongodb.org/static/pgp/server-4.4.asc
    EOL

    sudo yum install -y mongodb-org-4.4 mongodb-org-server-4.4 mongodb-org-shell-4.4 mongodb-org-mongos-4.4 mongodb-org-tools-4.4

    # Start MongoDB service
    sudo systemctl start mongod

    # Enable MongoDB service to start on boot
    sudo systemctl enable mongod

    # Wait for MongoDB to start
  EOF
}

output "instance_ip" {
  value = aws_instance.mongodb_instance.public_ip
}

  
   
