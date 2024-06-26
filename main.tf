resource "aws_instance" "mongo" {
  ami           = "ami-0edf386e462400a51"  # Replace with a suitable Amazon Linux 2 AMI
  instance_type = "t2.micro"
  key_name      = "project"  # Replace with your EC2 Key Pair name (must exist in AWS)

  vpc_security_group_ids = [aws_security_group.mongo_sg.id]

  tags = {
    Name = "MongoDBServer"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = self.public_ip
    }

    inline = [
      "sudo yum update -y",
      <<-EOT
      sudo tee /etc/yum.repos.d/mongodb-org-4.4.repo <<EOF
      [mongodb-org-4.4]
      name=MongoDB Repository
      baseurl=https://repo.mongodb.org/yum/amazon/2/mongodb-org/4.4/x86_64/
      enabled=1
      gpgkey=https://www.mongodb.org/static/pgp/server-4.4.asc
      EOF
      EOT
      ,
      "sudo yum install -y mongodb-org",
      {
        command = "sudo systemctl start mongod"
        execute_timeout = "5m"  # Timeout for starting MongoDB service
      },
      {
        command = "sudo systemctl enable mongod"
        execute_timeout = "1m"  # Timeout for enabling MongoDB service
      },
      {
        command = "mongo --eval 'db.createUser({user:\"admin\", pwd:\"password\", roles:[{role:\"root\", db:\"admin\"}]})'"
        execute_timeout = "2m"  # Timeout for creating MongoDB user
      },
      "sudo sed -i 's/#security:/security:\\n  authorization: enabled/' /etc/mongod.conf",
      {
        command = "sudo systemctl restart mongod"
        execute_timeout = "5m"  # Timeout for restarting MongoDB service
      }
    ]

    timeout = "15m"  # Overall timeout for all commands

    # Optional: Write a timeout for the entire connection operation
    connection_timeout = "2m"
  }
}
