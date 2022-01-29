####Setting up Subnets

resource "aws_subnet" "private_subnet_a" {
  vpc_id     = aws_vpc.asp_main_vpc.id
  cidr_block = cidrsubnet(var.cidr_block, 8, 0)
  availability_zone = "${var.region}a"
  tags = {
    Name = "private_subnet_a"
  }
} 

resource "aws_subnet" "public_subnet_a" {
  vpc_id     = aws_vpc.asp_main_vpc.id
  cidr_block = cidrsubnet(var.cidr_block, 8, 1)
  availability_zone = "${var.region}a"
  tags = {
    Name = "public_subnet_a"
  }
}

resource "aws_subnet" "private_subnet_b" {
  vpc_id     = aws_vpc.asp_main_vpc.id
  cidr_block = cidrsubnet(var.cidr_block, 8, 2)
  availability_zone = "${var.region}b"
  tags = {
    Name = "private_subnet_b"
  }
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id     = aws_vpc.asp_main_vpc.id
  cidr_block = cidrsubnet(var.cidr_block, 8, 3)
  availability_zone = "${var.region}b"
  tags = {
    Name = "public_subnet_b"
  }
}



