//I should get the vpc block and region as a variable and interpolate all the values here, this is the optimal way to use it.
//Usually I would write even the opt param
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


//In real world there should be way more subnets, I should create one for the db also.
//The subnets range are too big, this should be adjusted in the future.
resource "aws_subnet" "private_subnet_a" {
  vpc_id     = aws_vpc.asp_main_vpc.id
  cidr_block = "192.168.0.0/24"
  availability_zone = "${var.region}a"
  tags = {
    Name = "private_subnet"
  }
}

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
  route = []
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