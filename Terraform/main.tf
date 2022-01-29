//Internal modules <> external modules
variable "region" {default = "eu-west-1"}
variable "db_username" {sensitive = true }
variable "db_password" {sensitive = true }
//Not advised, security reasons 
provider "aws" {
  region     = var.region
}

//There should be variables here in order to reuse the internal module.
module "Network" {
  source  = "./Network"
  region = var.region
  cidr_block = "192.168.0.0/16"
}

module "Application" {
  source  = "./Application"
  vpc_id = module.Network.asp_vpc_id
  asp_public_subnet_a = module.Network.asp_public_subnet_a
  asp_public_subnet_b = module.Network.asp_public_subnet_b
  asp_private_subnet_a = module.Network.asp_private_subnet_a
  asp_private_subnet_b = module.Network.asp_private_subnet_b
  db_security_group_id =  module.Network.db_security_group_id
  instances_state = "running"
  //instances_state = "stopped"
  region = var.region
  db_username = var.db_username
  db_password = var.db_password
  ssh_key_name = "ASP" //PS.: This could be created on terraform, for security issues I won't handle this now.
}
