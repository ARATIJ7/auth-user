output "instance_ip" {
  description = "The public IP address of the MongoDB instance."
  value       = aws_instance.mongodb_instance.public_ip
}
