provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "mongodb" {
  ami           = var.ami_id
  instance_type = var.instance_type

  user_data = file("${path.module}/user_data.sh")

  tags = {
    Name = "MongoDBServer"
  }
}

output "instance_ip" {
  value = aws_instance.mongodb.public_ip
}
