//Internal modules <> external modules

//Not advised, security reasons 
provider "aws" {
  region     = "us-east-1"
  #access_key = ""
  #secret_key = ""
}


//There should be variables here in order to reuse the internal module.
module "Network" {
  source  = "./Network"
}

module "Orchestration" {
  source  = "./Orchestration"
  vpc_id = module.Network.asp_vpc_id
  asp_public_subnet_a = module.Network.asp_public_subnet_a
}
