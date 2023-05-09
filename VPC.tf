provider "aws" {
  region = "eu-central-1"
  access_key = ""
  secret_key = ""
}

# VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

# Create internet gateway and attach to VPC
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

# public subnet in the VPC
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-central-1a"
}

# public subnet in the VPC
resource "aws_subnet" "public2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.5.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-central-1b"
}

# private subnet in the VPC
resource "aws_subnet" "private1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"
  availability_zone       = "eu-central-1a"
}

# private subnet in the VPC
resource "aws_subnet" "private2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.4.0/24"
  availability_zone       = "eu-central-1b"
}

# route table for the public subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public"
  }
}

# Associate the public subnet with public route table
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

#-----------
# route table for the public subnet
resource "aws_route_table" "public2" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public2"
  }
}

# Associate the public subnet with public route table
resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public2.id
}
#-----------


# route table for the private subnet
resource "aws_route_table" "private1" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "privateT1"
  }
}

# Associate the private subnet with private route table
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private1.id
}


# route table for the private subnet
resource "aws_route_table" "private2" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "privateT2"
  }
}

# Associate the private subnet with private route table
resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private2.id
}


# NAT gateway in the public subnet
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.main.id
  subnet_id     = aws_subnet.public.id
}

# Allocate an Elastic IP address for the NAT gateway
resource "aws_eip" "main" {
  vpc = true
}

