##Setting up NatGw - 
#PS.:There should be two in order to avoid shortages when one zone is down
resource "aws_eip" "natgw_eip" {
  vpc      = true
}
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.natgw_eip.id
  subnet_id     = aws_subnet.public_subnet_a.id
  tags = {
    Name = "NAT gw"
  }
  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}
