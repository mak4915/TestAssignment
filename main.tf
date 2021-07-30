# VPC Creation
resource "aws_vpc" "myvpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "TF"
  }
}
# Public Subnet 1
resource "aws_subnet" "pub_sub1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.pub1_cidr
  availability_zone       = var.az1
  map_public_ip_on_launch = true
  tags = {
    Name = "Public-1"
  }
}
# Public Subnet 2
resource "aws_subnet" "pub_sub2" {


  vpc_id                  = aws_vpc.myvpc.id
  availability_zone       = var.az2
  cidr_block              = var.pub2_cidr
  map_public_ip_on_launch = true
  tags = {
    Name = "Public-2"
  }
}
#Private Subnet 1
resource "aws_subnet" "pri_sub1" {

  vpc_id                  = aws_vpc.myvpc.id
  availability_zone       = var.az1
  cidr_block              = var.pri1_cidr
  map_public_ip_on_launch = false
  tags = {
    Name = "Private-1"
  }


}
#Private Subnet 2
resource "aws_subnet" "pri_sub2" {
  vpc_id                  = aws_vpc.myvpc.id
  availability_zone       = var.az2
  cidr_block              = var.pri2_cidr
  map_public_ip_on_launch = false
  tags = {
    Name = "Private-2"
  }

}
# Security Group
resource "aws_security_group" "sg1" {
  name        = "SSH"
  description = "This will allow SSH"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    description = "Rule for SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    description = "Rule for HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Rule for Nginx"
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
  tags = {
    Name = "Allow SSH"
  }
}
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    "Name" = "Public_RT"
  }
}
# Route Table Private
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    "Name" = "Private-RT"
  }
}
# Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "TF"
  }
}
# Routes
resource "aws_route" "igw" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}
# Route Table Associations Public
resource "aws_route_table_association" "r1" {
  subnet_id      = aws_subnet.pub_sub1.id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table_association" "r2" {
  subnet_id      = aws_subnet.pub_sub2.id
  route_table_id = aws_route_table.public_rt.id
}
# Route Table Association Private
resource "aws_route_table_association" "r3" {
  subnet_id      = aws_subnet.pri_sub1.id
  route_table_id = aws_route_table.private_rt.id
}
resource "aws_route_table_association" "r4" {
  subnet_id      = aws_subnet.pri_sub2.id
  route_table_id = aws_route_table.private_rt.id
}