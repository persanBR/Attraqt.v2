resource "aws_opsworks_application" "api-app" {
  name        = "api-app"
  short_name  = "api-app"
  stack_id    = aws_opsworks_stack.main.id
  type        = "nodejs"
  description = "This is a nodejs application"
  environment {
    key    = "PORT"
    value  = "3000"
    secure = false
  }
  environment {
    key    = "DB"
    value  = "attraqtapp" ##PS.: Should be a variable
    secure = true
  }  
  environment {
    key    = "DBUSER"
    value  = var.db_username
    secure = false
  }
  environment {
    key    = "DBPASS"
    value  = var.db_password
    secure = true
  }
  environment {
    key    = "DBHOST"
    value  = aws_db_instance.postgres_db.address
    secure = false
  }
  environment {
    key    = "DBPORT"
    value  = aws_db_instance.postgres_db.port
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


resource "aws_opsworks_application" "web-app" {
  name        = "web-app"
  short_name  = "web-app"
  stack_id    = aws_opsworks_stack.main.id
  type        = "nodejs"
  description = "This is a nodejs application"
  environment {
    key    = "PORT"
    value  = "80"
    secure = false
  }
  environment {
    key    = "API_HOST"
    value  = aws_opsworks_instance.api-instance.private_ip           ##PS.: This should be a loadbalancer IPaddress
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