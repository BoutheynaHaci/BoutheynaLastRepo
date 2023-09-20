resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16" # Replace with your desired CIDR block
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "boutheyna-vpc"
  }
}


resource "aws_internet_gateway" "my_internet_gateway" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24" # Replace with your desired CIDR block for the public subnet
  availability_zone = "eu-west-3a"  # Replace with your desired availability zone in eu-west-3
}

resource "aws_subnet" "public_subnet2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.2.0/24" # Replace with your desired CIDR block for the public subnet
  availability_zone = "eu-west-3b"  # Replace with your desired availability zone in eu-west-3
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.3.0/24" # Replace with your desired CIDR block for the private subnet
  availability_zone = "eu-west-3a"  # Replace with your desired availability zone in eu-west-3
}

#route table
resource "aws_route_table" "public_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_internet_gateway.id
  }

  tags = {
    Name = "public_route_table"
  }
}

resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "internet_gateway"
  }
}

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_table.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public_table.id
}


resource "aws_route_table" "private_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "private_route_table"
  }
}

resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_table.id
}