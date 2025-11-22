# Create VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "anime-vpc"
  }
}

# Create subnet
resource "aws_subnet" "main_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "anime-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "anime-igw"
  }
}

# Route table
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "anime-rt"
  }
}

# Associate route table with subnet
resource "aws_route_table_association" "rt_assoc" {
  subnet_id      = aws_subnet.main_subnet.id
  route_table_id = aws_route_table.rt.id
}

# Security Group (3000 + 22 open)
resource "aws_security_group" "anime_sg" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "anime-sg"
  }
}

# ----------------------------
# EC2 Instance
# us-east-1 AMI (Amazon Linux 2)
# ----------------------------

resource "aws_instance" "anime_server" {
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2 AMI for us-east-1
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = aws_subnet.main_subnet.id
  vpc_security_group_ids = [aws_security_group.anime_sg.id]

  tags = {
    Name = "anime-web-server"
  }
}
