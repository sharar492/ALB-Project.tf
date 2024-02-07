# VPC assignment
resource "aws_vpc" "vpc-asg" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# Subnet 1 for VPC
resource "aws_subnet" "subnet-1" {
  vpc_id                  = aws_vpc.vpc-asg.id
  cidr_block              = var.cidr_subnet1
  availability_zone       = var.availability_zone_subnet1
  map_public_ip_on_launch = true  

  tags = {
    Name = "subnet-1"
  }
}

# Subnet 2 for the VPC
resource "aws_subnet" "subnet-2" {
  vpc_id                  = aws_vpc.vpc-asg.id
  cidr_block              = var.cidr_subnet2
  availability_zone       = var.availability_zone_subnet2

  tags = {
    Name = "subnet-2"
  }
}

# Internet Gateway for VPC
resource "aws_internet_gateway" "igw1" {
  vpc_id = aws_vpc.vpc-asg.id
}

# Route Table 1 for subnet 1
resource "aws_route_table" "rt-1" {
  vpc_id = aws_vpc.vpc-asg.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw1.id
  }
}

# Elastic IP for the NAT Gateway
resource "aws_eip" "nat_allocation" {
  instance = null  
}

# NAT Gateway for the private subnet for subnet 2
resource "aws_nat_gateway" "private-nat-subnet2" {
  subnet_id     = aws_subnet.subnet-2.id
  allocation_id = aws_eip.nat_allocation.id

  tags = {
    Name = "NAT for private subnet"
  }
}

# Route Table 2 for subnet 2
resource "aws_route_table" "rt-2-private" {
  vpc_id = aws_vpc.vpc-asg.id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.private-nat-subnet2.id
  }
}

# Route table association for subnet 1
resource "aws_route_table_association" "rt-sh-1" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.rt-1.id
}

# Route table association for subnet 2
resource "aws_route_table_association" "rt-sh-2" {
  subnet_id      = aws_subnet.subnet-2.id
  route_table_id = aws_route_table.rt-2-private.id
}



resource "aws_security_group" "sg-1" {
  name        = "security-group-for-load-balancer"
  description = "allow traffic"
  vpc_id      = aws_vpc.vpc-asg.id

  ingress {
    description = "Allow HTTP request from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS request from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sg-2" {
  name   = "security-group-for-load-balancer-private"
  vpc_id = aws_vpc.vpc-asg.id

  ingress {
    description     = "Allow HTTP request from the load balancer security group"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.sg-1.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

