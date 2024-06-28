variable "region" {
  description = "The AWS region to create resources in."
  default     = "us-east-2"
}

variable "key_name" {
  description = "The name of the SSH key pair."
  default     = "terraform-key"
}

variable "public_key_path" {
  description = "Path to the public key to use for SSH access."
  default     = "~/.ssh/id_rsa.pub"
}

variable "ami" {
  description = "The AMI ID to use for the instance."
  default     = "ami-024ebc7de0fc64e44"  # Amazon Linux 2 AMI (change as needed)
}

variable "instance_type" {
  description = "The type of instance to use."
  default     = "t2.micro"
}

variable "allowed_cidrs" {
  description = "List of CIDR blocks allowed to access MongoDB."
  type        = list(string)
  default     = ["0.0.0.0/0"]  # Open to the world, change as needed for security
}
