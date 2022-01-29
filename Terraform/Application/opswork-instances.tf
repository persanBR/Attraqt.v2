##PS.: The best way to use would be create custom layers for Backend and Frontend
resource "aws_opsworks_custom_layer" "asp_custom_fe_app" {
  stack_id = aws_opsworks_stack.main.id
  short_name = "weblayer"
  name = "Web Application Layer"
  auto_assign_elastic_ips = true
}

resource "aws_opsworks_custom_layer" "asp_custom_be_app" {
  stack_id = aws_opsworks_stack.main.id
  short_name = "apilayer"
  name = "API Application Layer"
  auto_assign_elastic_ips = false
}

##PS.:There should be a load ballancer
##PS.:Instance type is pv, dont want to manage disks now, change latter.
resource "aws_opsworks_instance" "web-instance" {
  stack_id = aws_opsworks_stack.main.id
  layer_ids = [
    aws_opsworks_custom_layer.asp_custom_fe_app.id,
  ]
  hostname = "frontend-1a"
  subnet_id  = var.asp_public_subnet_a
  instance_type = "m3.medium" 
  os            = "Amazon Linux 2018.03"
  state         = var.instances_state
  ssh_key_name = var.ssh_key_name

  timeouts {
    create = "20m"
    delete = "20m"
  }
}

resource "aws_opsworks_instance" "api-instance" {
  stack_id = aws_opsworks_stack.main.id
  layer_ids = [
    aws_opsworks_custom_layer.asp_custom_be_app.id,
  ]
  hostname = "backend-1a"
  subnet_id  = var.asp_private_subnet_a
  instance_type = "m3.medium" 
  os            = "Amazon Linux 2018.03"
  state         = var.instances_state
  ssh_key_name = var.ssh_key_name
  timeouts {
    create = "20m"
    delete = "20m"
  }
}

resource "aws_opsworks_rds_db_instance" "my_db_instance" {
  stack_id            = aws_opsworks_stack.main.id
  rds_db_instance_arn = aws_db_instance.mysql_db.arn
  db_user             = var.db_username
  db_password         = var.db_password
}

//there should be layers for node backend and frontend