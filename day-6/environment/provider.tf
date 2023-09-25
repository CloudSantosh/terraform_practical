#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#  configure aws provider
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
terraform {
  #required_version = ">= 1.4.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

provider "aws" {
  //region  = terraform.workspace=="dev"?"us-east-1":terraform.workspace=="prod"?"us-east-2":"us-west-1"
  //region  = terraform.workspace=="dev"?var.region:terraform.workspace=="prod"?var.region:var.region
  region  = terraform.workspace=="dev"?var.region_dev:terraform.workspace=="prod"?var.region_prod:var.region_stage
  profile = terraform.workspace
}
