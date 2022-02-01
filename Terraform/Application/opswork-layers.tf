resource "aws_opsworks_custom_layer" "asp_custom_fe_app" {
  stack_id = aws_opsworks_stack.main.id
  short_name = "weblayer"
  name = "Web Application Layer"
  auto_assign_elastic_ips = true
  custom_setup_recipes = [
    "setup::app",
  ]
  custom_deploy_recipes = [
    "deploy::app",
  ]
}

resource "aws_opsworks_custom_layer" "asp_custom_be_app" {
  stack_id = aws_opsworks_stack.main.id
  short_name = "apilayer"
  name = "API Application Layer"
  auto_assign_elastic_ips = false
  custom_setup_recipes = [
    "setup::app",
  ]
  custom_deploy_recipes = [
    "deploy::app",
  ]
}
