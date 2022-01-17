output "asp_vpc_id" {
  value = aws_vpc.asp_main_vpc.id
}

output "asp_public_subnet_a" {
  value = aws_subnet.public_subnet_a.id
}

