//Internal modules <> external modules

//Not advised, security reasons 
provider "aws" {
  region     = "us-east-1"
  #access_key = ""
  #secret_key = ""
}

variable "db_username" {sensitive = true }
variable "db_password" {sensitive = true }


//There should be variables here in order to reuse the internal module.
module "Network" {
  source  = "./Network"
  region = "us-east-1"
}

module "Orchestration" {
  source  = "./Application"
  vpc_id = module.Network.asp_vpc_id
  asp_public_subnet_a = module.Network.asp_public_subnet_a
  asp_public_subnet_b = module.Network.asp_public_subnet_b
  asp_private_subnet_a = module.Network.asp_private_subnet_a
  asp_private_subnet_b = module.Network.asp_private_subnet_b
  instances_state = "stopped"
  region = "us-east-1"
  db_username = var.db_username
  db_password = var.db_password
}
