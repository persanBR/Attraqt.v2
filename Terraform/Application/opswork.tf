//there should be a module to handle IAM.
//I should validate the role, https://docs.aws.amazon.com/opsworks/latest/userguide/opsworks-security-servicerole.html there seems to be more allowing than needed.


resource "aws_iam_role" "opswork_service_role" {
  name = "OpsworkServiceRole"
  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "StsAssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "opsworks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "opswork_service_role_policy_attach" {
   role       = "${aws_iam_role.opswork_service_role.name}"
   policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_instance_profile" "opswork_instance_profile" {
  name = "opswork_instance_profile"
  role = "${aws_iam_role.opswork_instance_role.name}"
}

resource "aws_iam_role" "opswork_instance_role" {
  name = "opswork_instance_role"
  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "StsAssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


resource "aws_opsworks_stack" "main" {
  name                         = "ASP-Stack"
  vpc_id                       = var.vpc_id
  default_subnet_id            = var.asp_public_subnet_a
  region                       = "${var.region}"
  service_role_arn             =  aws_iam_role.opswork_service_role.arn
  default_instance_profile_arn = aws_iam_instance_profile.opswork_instance_profile.arn
}


resource "aws_opsworks_nodejs_app_layer" "asp_app" {
  stack_id = aws_opsworks_stack.main.id
  nodejs_version = "0.12.18"
}

//there should be a load ballancer
//instance type is pv, dont want to manage disks
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

resource "aws_opsworks_rds_db_instance" "my_db_instance" {
  stack_id            = aws_opsworks_stack.main.id
  rds_db_instance_arn = aws_db_instance.mysql_db.arn
  db_user             = var.db_username
  db_password         = var.db_password
}