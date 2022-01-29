resource "aws_security_group" "db_sg" {
  name        = "database_connection"
  description = "Allow db communication"
  vpc_id      = aws_vpc.asp_main_vpc.id

  ingress {
    description      = "Instances to DB"
    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
    cidr_blocks      = [cidrsubnet(var.cidr_block, 8, 0),cidrsubnet(var.cidr_block, 8, 2)]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "database_connection"
  }
}