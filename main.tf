provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "mongodb" {
  ami           = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name = "MongoDBServer"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y mongodb-org",
      "sudo systemctl start mongod",
      "sudo systemctl enable mongod"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("${path.module}/keys/my-key.pem")
      host        = self.public_ip
    }
  }
}
