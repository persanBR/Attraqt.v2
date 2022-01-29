//there should be a module to handle IAM.
//I should validate the role, https://docs.aws.amazon.com/opsworks/latest/userguide/opsworks-security-servicerole.html there seems to be more allowing than needed.
//None of this pol should be adm

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
  depends_on = [
    aws_iam_role.opswork_instance_role,
  ]
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

resource "aws_iam_instance_profile" "opswork_instance_profile" {
  name = "opswork_instance_profile"
  role = "${aws_iam_role.opswork_instance_role.name}"
}
resource "aws_iam_role_policy_attachment" "instance_profile_attach" {
  role       = aws_iam_role.opswork_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  depends_on = [ //Trying to handle destruction mode
    aws_iam_instance_profile.opswork_instance_profile,
  ]
}

resource "aws_opsworks_stack" "main" {
  name                         = "ASP-Stack"
  vpc_id                       = var.vpc_id
  default_subnet_id            = var.asp_private_subnet_a
  region                       = "${var.region}"
  service_role_arn             =  aws_iam_role.opswork_service_role.arn
  default_instance_profile_arn = aws_iam_instance_profile.opswork_instance_profile.arn
  use_custom_cookbooks = true
  custom_cookbooks_source {
    type = "git"
    url = "https://github.com/aws/opsworks-cookbooks/"
  }
}

