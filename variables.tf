variable "aws_region" {
  description = "The AWS region to deploy to"
  default     = "us-east-2"
}

variable "ami_id" {
  description = "The AMI ID to use for the instance"
  default     = "ami-024ebc7de0fc64e44" # Example Amazon Linux 2 AMI
}

variable "instance_type" {
  description = "The instance type to use"
  default     = "t2.micro"
}

variable "key_name" {
  description = "The key name to use"
  default     = "project"
}

