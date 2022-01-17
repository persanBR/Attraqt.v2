//there should be a module to handle IAM.
//I should validate the role, https://docs.aws.amazon.com/opsworks/latest/userguide/opsworks-security-servicerole.html there seems to be more allowing than needed.
resource "aws_iam_policy" "policy" {
  name        = "opsworks_stack_policy"
  description = "OpsworksStackPolicy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "ec2:*",
                "iam:PassRole",
                "cloudwatch:GetMetricStatistics",
                "cloudwatch:DescribeAlarms",
                "ecs:*",
                "elasticloadbalancing:*",
                "rds:*"
            ],
            "Effect": "Allow",
            "Resource": [
                "*"
            ],
            "Condition": {
                "StringEquals": {
                    "iam:PassedToService": "ec2.amazonaws.com"
                }
            }
        }
    ]
}
EOF
}

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
   policy_arn = "${aws_iam_policy.policy.arn}"
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
  name                         = "ASP-terraform"
  vpc_id                       = var.vpc_id
  default_subnet_id            = var.asp_public_subnet_a
  region                       = "us-east-1"
  service_role_arn             =  aws_iam_role.opswork_service_role.arn
  default_instance_profile_arn = aws_iam_instance_profile.opswork_instance_profile.arn

  tags = {
    Name = "ASP-terraform"
  }
}