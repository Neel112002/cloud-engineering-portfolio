terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ca-central-1"
}

############################
# Networking: VPC + Subnet
############################

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name    = "project04-vpc"
    Project = "Project04-vpc-ec2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name    = "project04-igw"
    Project = "Project04-vpc-ec2"
  }
}

# One public subnet in ca-central-1a
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ca-central-1a"
  map_public_ip_on_launch = true

  tags = {
    Name    = "project04-public-subnet"
    Project = "Project04-vpc-ec2"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name    = "project04-public-rt"
    Project = "Project04-vpc-ec2"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

############################
# Security Group
############################

resource "aws_security_group" "web_sg" {
  name        = "project04-web-sg"
  description = "Allow HTTP and SSH"
  vpc_id      = aws_vpc.main.id

  # Allow HTTP from anywhere (for demo)
  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH from anywhere (for lab/demo)
  # In real life, restrict this to your IP.
  ingress {
    description = "SSH from internet (demo only)"
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
    Name    = "project04-web-sg"
    Project = "Project04-vpc-ec2"
  }
}

############################
# EC2 Instance (Web Server)
############################

# Get latest Amazon Linux 2 AMI in ca-central-1
data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["137112412989"] # Amazon Linux owner

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro" # free tier eligible
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  # Optional: add your key pair name here if you want SSH access
  # key_name = "your-keypair-name"

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y nginx
              systemctl enable nginx
              systemctl start nginx

              echo "<html>
              <head><title>Project 04 - VPC + EC2</title></head>
              <body style='font-family: system-ui; text-align: center; padding-top: 40px;'>
              <h1>Project 04 – VPC + EC2 Web Server</h1>
              <p>Deployed in a custom VPC public subnet using Terraform.</p>
              <p>Region: ca-central-1</p>
              </body>
              </html>" > /usr/share/nginx/html/index.html
              EOF

  tags = {
    Name    = "project04-web-ec2"
    Project = "Project04-vpc-ec2"
  }
}
