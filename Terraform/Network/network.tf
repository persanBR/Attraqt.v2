##PS.: I should get the vpc block and region as a variable and interpolate all the values here, this is the optimal way to use it.

resource "aws_vpc" "asp_main_vpc" {
  cidr_block       = "192.168.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "asp_main_vpc"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.asp_main_vpc.id
  tags = {
    Name = "asp_main_igw"
  }
}


##PS.: In real world there should be way more subnets, it should have one for the db also.
##PS.: The subnets range are too big, this should be adjusted in the future.
resource "aws_subnet" "private_subnet_a" {
  vpc_id     = aws_vpc.asp_main_vpc.id
  cidr_block = "192.168.0.0/24"
  availability_zone = "${var.region}a"
  tags = {
    Name = "private_subnet"
  }
}

####Setting up Subnets
resource "aws_subnet" "public_subnet_a" {
  vpc_id     = aws_vpc.asp_main_vpc.id
  cidr_block = "192.168.1.0/24"
  availability_zone = "${var.region}a"
  tags = {
    Name = "public_subnet"
  }
}
resource "aws_subnet" "private_subnet_b" {
  vpc_id     = aws_vpc.asp_main_vpc.id
  cidr_block = "192.168.3.0/24"
  availability_zone = "${var.region}b"
  tags = {
    Name = "private_subnet"
  }
}
resource "aws_subnet" "public_subnet_b" {
  vpc_id     = aws_vpc.asp_main_vpc.id
  cidr_block = "192.168.4.0/24"
  availability_zone = "${var.region}b"
  tags = {
    Name = "public_subnet"
  }
}

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