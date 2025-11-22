# AWS Region
variable "aws_region" {
  description = "AWS Region to deploy resources"
  type        = string
  default     = "us-east-1"
}

# Instance type
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

# SSH Key Pair Name (created in AWS)
variable "key_name" {
  description = "Name of the SSH key pair for EC2"
  type        = string
  default     = "anime-web-key"
}

# Public key content (from GitHub secret)
variable "ssh_public_key" {
  description = "Public key for EC2 SSH access"
  type        = string
}

# Docker Hub credentials
variable "dockerhub_user" {
  description = "Docker Hub username"
  type        = string
}

variable "dockerhub_token" {
  description = "Docker Hub password/token"
  type        = string
}
