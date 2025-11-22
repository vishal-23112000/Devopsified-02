# -----------------------------
# VPC
# -----------------------------
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = { Name = "anime-web-vpc" }
}

# -----------------------------
# Subnet
# -----------------------------
resource "aws_subnet" "main_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = { Name = "anime-web-subnet" }
}

# -----------------------------
# Internet Gateway
# -----------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags   = { Name = "anime-web-igw" }
}

# -----------------------------
# Route Table
# -----------------------------
resource "aws_route_table" "main_rt" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "anime-web-rt" }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.main_subnet.id
  route_table_id = aws_route_table.main_rt.id
}

# -----------------------------
# Security Group
# -----------------------------
resource "aws_security_group" "anime_sg" {
  name        = "anime-web-sg"
  description = "Allow HTTP and SSH"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "anime-web-sg" }
}

# -----------------------------
# Key Pair
# -----------------------------
resource "aws_key_pair" "anime_key" {
  key_name   = var.key_name
  public_key = var.ssh_public_key
}

# -----------------------------
# EC2 Instance
# -----------------------------
resource "aws_instance" "anime_server" {
  ami                    = "ami-0c02fb55956c7d316" # Amazon Linux 2 (us-east-1)
  instance_type          = var.instance_type
  key_name               = aws_key_pair.anime_key.key_name
  subnet_id              = aws_subnet.main_subnet.id
  vpc_security_group_ids = [aws_security_group.anime_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install docker -y
              service docker start
              usermod -a -G docker ec2-user
              docker login -u ${var.dockerhub_user} -p ${var.dockerhub_token}
              docker pull vyavaharevishal/anime-web:latest
              docker run -d -p 3000:3000 vyavaharevishal/anime-web:latest
              EOF

  tags = { Name = "anime-web-server" }
}
