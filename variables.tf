variable "aws_region" {
  description = "The AWS region to deploy to"
  default     = "us-west-2"
}

variable "ami_id" {
  description = "The AMI ID to use for the instance"
  default     = "ami-0c55b159cbfafe1f0" # Example Amazon Linux 2 AMI
}

variable "instance_type" {
  description = "The instance type to use"
  default     = "t2.micro"
}

variable "private_key_path" {
  description = "Path to the private key for SSH access"
  default     = "~/.ssh/my-key.pem"
}