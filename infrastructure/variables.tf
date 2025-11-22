# AWS Region
variable "region" {
  default = "us-east-1"
}

# EC2 Instance Type
variable "instance_type" {
  default = "t2.micro"
}

# SSH Key Pair Name (create in AWS → EC2 → Key Pairs)
variable "key_name" {
  default = "my-key"
}
