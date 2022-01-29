
##Setting up Routing
resource "aws_route_table" "asp_public_route" {
  vpc_id = aws_vpc.asp_main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "asp_public_route"
  }
}

resource "aws_route_table" "asp_private_route" {
  vpc_id = aws_vpc.asp_main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw.id
  }
  tags = {
    Name = "asp_private_route"
  }
}

resource "aws_route_table_association" "private-a" {
  subnet_id      = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.asp_private_route.id
}

resource "aws_route_table_association" "public-a" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.asp_public_route.id
}

resource "aws_route_table_association" "private-b" {
  subnet_id      = aws_subnet.private_subnet_b.id
  route_table_id = aws_route_table.asp_private_route.id
}

resource "aws_route_table_association" "public-b" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.asp_public_route.id
}