# provider.tf
provider "aws" {
  region = var.region_name
}

# vpc.tf
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name    = var.vpc_tag
    Service = "Terraform"
  }
}

# subnet.tf
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidr_block
  map_public_ip_on_launch = true
  availability_zone       = var.subnet_az

  tags = {
    Name    = var.subnet_tag
    Service = "Terraform"
  }
}

# internet_gateway.tf
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name    = var.igw_tag
    Service = "Terraform"
  }
}

# route_table.tf
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.rt_cidr_block
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name    = var.rt_tag
    Service = "Terraform"
  }
}

# route_table_association.tf
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# security_groups.tf
resource "aws_security_group" "allow_all" {
  vpc_id = aws_vpc.main.id
  name   = "allow_all"


  ingress {
    description = "Allow all inbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "SG-Terra"
    Service = "Terraform"
  }
}

# ec2.tf
resource "aws_instance" "web-1" {
  ami                         = "ami-0e2c8caa4b6378d8c"
  instance_type               = var.ec2_type
  availability_zone           = var.ec2_az
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.allow_all.id]
  associate_public_ip_address = true

  tags = {
    Name       = "Prod-Server"
    Env        = "Prod"
    Owner      = "bhavna"
    CostCenter = "ABCD"
  }
}
