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
}

module "Orchestration" {
  source  = "./Application"
  vpc_id = module.Network.asp_vpc_id
  asp_public_subnet_a = module.Network.asp_public_subnet_a
  asp_public_subnet_b = module.Network.asp_public_subnet_b
  asp_private_subnet_a = module.Network.asp_private_subnet_a
  asp_private_subnet_b = module.Network.asp_private_subnet_b
  //instances_state = "running"
  instances_state = "stopped"
  region = var.region
  db_username = var.db_username
  db_password = var.db_password
}
