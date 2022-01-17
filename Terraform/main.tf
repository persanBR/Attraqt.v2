//Internal modules <> external modules

//Not advised, security reasons 
provider "aws" {
  region     = "us-east-1"
  access_key = "AKIA3UC6JCH3VEUG4MN4"
  secret_key = "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"
}


//There should be variables here in order to reuse the internal module.
module "Network" {
  source  = "./Network"
}

module "Orchestration" {
  source  = "./Orchestration"
}
