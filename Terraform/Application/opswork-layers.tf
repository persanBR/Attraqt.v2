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
