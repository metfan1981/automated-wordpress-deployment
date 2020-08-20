resource "aws_vpc" "custom-vpc" {
  cidr_block           = var.cidr_vpc
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  instance_tenancy     = "default"

  tags = {
    Name = var.vpc_name
  }
}


resource "aws_subnet" "public-subnet" {
  vpc_id                  = aws_vpc.custom-vpc.id
  cidr_block              = var.cidr_public_subnet
  map_public_ip_on_launch = "true"
  availability_zone       = var.az
}


resource "aws_security_group" "common_ports-public" {
  vpc_id = aws_vpc.custom-vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8085
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr_public_subnet}"]
  }

  tags = {
    Name = "public-web-ssh_private-sql"
  }
}


resource "aws_instance" "web" {
  ami                    = var.ami
  count                  = var.web_instance_count
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public-subnet.id
  vpc_security_group_ids = [aws_security_group.common_ports-public.id]
  key_name               = var.ssh_key

  tags = {
    Name = "web-${count.index + 1}"
  }
}


resource "aws_instance" "db" {
  ami                    = var.ami
  count                  = var.db_instance_count
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public-subnet.id
  vpc_security_group_ids = [aws_security_group.common_ports-public.id]
  key_name               = var.ssh_key

  tags = {
    Name = "db-${count.index + 1}"
  }
}


resource "aws_internet_gateway" "custom-igw" {
  vpc_id = aws_vpc.custom-vpc.id
}


resource "aws_route_table" "route_table_public" {
  vpc_id = aws_vpc.custom-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.custom-igw.id
  }
}


resource "aws_route_table_association" "pub_routes" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.route_table_public.id
}

