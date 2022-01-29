resource "aws_db_instance" "postgres_db" {
  allocated_storage    = 50
  identifier           = "postgresdb" //PS.: This should not be used
  engine               = "postgres"
  engine_version       = "13.4"
  instance_class       = "db.t3.micro"
  name                 = "attraqtapp"
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.postgres13"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.db-default.name
  vpc_security_group_ids = [var.db_security_group_id]
}

resource "aws_db_subnet_group" "db-default" {
  name       = "db-default-subnetgroup"
  subnet_ids = [var.asp_private_subnet_a, var.asp_private_subnet_b]
}