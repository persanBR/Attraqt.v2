resource "aws_db_instance" "mysql_db" {
  allocated_storage    = 50
  identifier           = "mysqldb"
  engine               = "mysql"
  engine_version       = "8.0.23"
  instance_class       = "db.t3.micro"
  name                 = "mysqldb"
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.db-default.name
}


resource "aws_db_subnet_group" "db-default" {
  name       = "db-default-subnetgroup"
  subnet_ids = [var.asp_private_subnet_a, var.asp_private_subnet_b]
}