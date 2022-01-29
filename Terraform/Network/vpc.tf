##PS.: I should get the vpc block and region as a variable and interpolate all the values here, this is the optimal way to use it.

resource "aws_vpc" "asp_main_vpc" {
  cidr_block       = var.cidr_block
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


