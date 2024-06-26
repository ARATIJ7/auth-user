resource "aws_instance" "mongo" {
  ami           = "ami-0edf386e462400a51"  # Replace with a suitable Amazon Linux 2 AMI
  instance_type = "t2.micro"
  key_name      = "project"  # Replace with your EC2 Key Pair name (must exist in AWS)

  vpc_security_group_ids = [aws_security_group.mongo_sg.id]

  tags = {
    Name = "MongoDBServer"
  }

  provisioner "remote-exec" {
    # Other configuration
    timeout = "10m"  # Adjust timeout as necessary
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
      "sudo systemctl start mongod",
      "sudo systemctl enable mongod",
      "mongo --eval 'db.createUser({user:\"admin\", pwd:\"password\", roles:[{role:\"root\", db:\"admin\"}]})'",
      "sudo sed -i 's/#security:/security:\\n  authorization: enabled/' /etc/mongod.conf",
      "sudo systemctl restart mongod"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      # No need for private_key when using key_name
      host        = self.public_ip
    }
  }
}
