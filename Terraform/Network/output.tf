output "asp_vpc_id" {
  value = aws_vpc.asp_main_vpc.id
}
output "asp_public_subnet_a" {
  value = aws_subnet.public_subnet_a.id
}
output "asp_public_subnet_b" {
  value = aws_subnet.public_subnet_b.id
}
output "asp_private_subnet_a" {
  value = aws_subnet.private_subnet_a.id
}
output "asp_private_subnet_b" {
  value = aws_subnet.private_subnet_b.id
}
output "db_security_group_id" {
    value = aws_security_group.db_sg.id
} 