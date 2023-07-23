terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0, < 4.0"  # Replace with the compatible version
    }
  }
}

provider "aws" {
  region = "us-east-1"  # Replace with your desired AWS region
}

# Create a VPC for the instances
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

# Create a public subnet for the server with internet access
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.region}a"
}

# Create a private subnet for the client without internet access
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${var.region}a"
}

# Create an internet gateway for the public subnet
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

# Create a public route table for the public subnet
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

# Associate the public route table with the public subnet
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# Create a security group allowing SSH and HTTP access to the server from the internet
resource "aws_security_group" "server_sg" {
  name        = "server-security-group"
  description = "Security group for the server instance"

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.main.id
}

# Create a security group allowing SSH access for the client
resource "aws_security_group" "client_sg" {
  name        = "client-security-group"
  description = "Security group for the client instance"

  ingress {
    description = "SSH access"
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

  vpc_id = aws_vpc.main.id
}

# Launch the server instance in the public subnet
resource "aws_instance" "server" {
  ami                    = "ami-05bfc1ab11bfbf484"  # Ubuntu 20.04 LTS (replace with the desired AMI ID)
  instance_type          = "t2.micro"  # Replace with your desired instance type
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.server_sg.id]

  key_name               = var.key_name  # Specify the SSH key pair name you have in your AWS account

  tags = {
    Name = "server"
  }
}

# Launch the client instance in the private subnet
resource "aws_instance" "client" {
  ami                    = "ami-05bfc1ab11bfbf484"  # Ubuntu 20.04 LTS (replace with the desired AMI ID)
  instance_type          = "t2.micro"  # Replace with your desired instance type
  subnet_id              = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.client_sg.id]

  key_name               = var.key_name  # Specify the SSH key pair name you have in your AWS account

  tags = {
    Name = "client"
  }
}

resource "aws_key_pair" "mykey-pair" {
  key_name   = "mykey-pair"
  public_key = file(var.PUBLIC_KEY_PATH)
}

# creating Elastic IP for Server
resource "aws_eip" "eip_1" {
  instance = aws_instance.server.id
}
