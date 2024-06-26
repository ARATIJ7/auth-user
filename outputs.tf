output "instance_ip" {
  description = "The public IP of the MongoDB instance"
  value       = aws_instance.mongodb.public_ip
}
