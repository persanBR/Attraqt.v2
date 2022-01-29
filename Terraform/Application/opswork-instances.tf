##PS.: The best way to use would be create custom layers for Backend and Frontend

resource "aws_opsworks_nodejs_app_layer" "asp_app" {
  stack_id = aws_opsworks_stack.main.id
  nodejs_version = "0.12.18"
  name = "Frontend App Server"
  auto_assign_elastic_ips = true
}

##PS.:There should be a load ballancer
##PS.:Instance type is pv, dont want to manage disks
resource "aws_opsworks_instance" "web-instance" {
  stack_id = aws_opsworks_stack.main.id

  layer_ids = [
    aws_opsworks_nodejs_app_layer.asp_app.id,
  ]
  hostname = "frontend-1a"
  subnet_id  = var.asp_public_subnet_a
  instance_type = "m1.medium" 
  os            = "Amazon Linux 2018.03"
  state         = var.instances_state
}

resource "aws_opsworks_instance" "api-instance" {
  stack_id = aws_opsworks_stack.main.id

  layer_ids = [
    aws_opsworks_nodejs_app_layer.asp_app.id,
  ]
  hostname = "backend-1a"
  subnet_id  = var.asp_private_subnet_a
  instance_type = "m1.medium" 
  os            = "Amazon Linux 2018.03"
  state         = var.instances_state
}

resource "aws_opsworks_rds_db_instance" "my_db_instance" {
  stack_id            = aws_opsworks_stack.main.id
  rds_db_instance_arn = aws_db_instance.mysql_db.arn
  db_user             = var.db_username
  db_password         = var.db_password
}

//there should be layers for node backend and frontend