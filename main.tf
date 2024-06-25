provider "aws" {
  region = "us-east-2"  # Replace with your desired region
}

resource "aws_instance" "mongo" {
  ami           = "ami-0edf386e462400a51"  # Replace with a suitable Amazon Linux 2 AMI
  instance_type = "t2.micro"
  key_name      = "project"  # Replace with your key pair

  tags = {
    Name = "MongoDBServer"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y mongodb-org",
      "sudo systemctl start mongod",
      "sudo systemctl enable mongod",
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("path/to/your/private-key.pem")  # Replace with your private key path
      host        = self.public_ip
    }
  }
}

resource "aws_security_group" "mongo_sg" {
  name        = "mongo_sg"
  description = "Allow MongoDB inbound traffic"

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mongo_sg"
  }
}

resource "aws_instance" "mongo" {
  ami           = "ami-0c55b159cbfafe1f0"  # Replace with a suitable Amazon Linux 2 AMI
  instance_type = "t2.micro"
  key_name      = "your-key-pair"  # Replace with your key pair

  vpc_security_group_ids = [aws_security_group.mongo_sg.id]

  tags = {
    Name = "MongoDBServer"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo tee /etc/yum.repos.d/mongodb-org-4.4.repo <<EOF
      [mongodb-org-4.4]
      name=MongoDB Repository
      baseurl=https://repo.mongodb.org/yum/amazon/2/mongodb-org/4.4/x86_64/
      gpgcheck=1
      enabled=1
      gpgkey=https://www.mongodb.org/static/pgp/server-4.4.asc
      EOF",
      "sudo yum install -y mongodb-org",
      "sudo systemctl start mongod",
      "sudo systemctl enable mongod",
      "mongo --eval 'db.createUser({user:\"admin\", pwd:\"password\", roles:[{role:\"root\", db:\"admin\"}]})'",
      "sudo sed -i 's/#security:/security:\\n  authorization: enabled/' /etc/mongod.conf",
      "sudo systemctl restart mongod"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("path/to/your/private-key.pem")  # Replace with your private key path
      host        = self.public_ip
    }
  }
}
