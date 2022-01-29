resource "aws_opsworks_application" "api-app" {
  name        = "api application"
  short_name  = "api-app"
  stack_id    = aws_opsworks_stack.main.id
  type        = "nodejs"
  description = "This is a nodejs application"

  environment {
    key    = "alaan"
    value  = "alan"
    secure = false
  }

  app_source {
    type     = "git"
    revision = "main"
    url      = "https://github.com/persanBR/node-3tier-app.git"
  }

  ##PS.: should be true or do a ssloffload somewhere else
  enable_ssl = false

}