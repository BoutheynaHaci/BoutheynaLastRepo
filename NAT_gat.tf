#creates an Elastic IP (aws_eip)
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

#creates Nat gateway in the private subnet 
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.private_subnet.id
  tags = {
    Name = "Bouth_nat_gateway"
  }
  depends_on = [
    aws_internet_gateway.my_internet_gateway
  ]
}