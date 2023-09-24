
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# create VPC
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
module "vpc" {
  source                = "../modules/vpc"
  //region                = terraform.workspace=="dev"?"us-east-1":terraform.workspace=="prod"?"us-east-2":"us-west-1"
  region                = terraform.workspace=="dev"?var.region:terraform.workspace=="prod"?var.region:var.region
  project_name          = var.project_name
  //vpc_cidr              = terraform.workspace=="dev"?"192.168.0.0/16":terraform.workspace=="prod"?"192.162.0.0/16":"192.100.0.0/16"
  //vpc_cidr              = terraform.workspace=="dev"?var.vpc_cidr_dev:terraform.workspace=="prod"?var.vpc_cidr_prod:var.vpc_cidr_stage 
  vpc_cidr              = terraform.workspace=="dev"?var.vpc_cidr:terraform.workspace=="prod"?var.vpc_cidr:var.vpc_cidr 
  //public_subnet_az_cidr =terraform.workspace=="dev"?var.public_subnet_az_cidr_dev:terraform.workspace=="prod"?var.public_subnet_az_cidr_prod:var.public_subnet_az_cidr_stage 
  public_subnet_az_cidr =terraform.workspace=="dev"?var.public_subnet_az_cidr:terraform.workspace=="prod"?var.public_subnet_az_cidr:var.public_subnet_az_cidr
  //public_subnet_az_cidr = var.public_subnet_az_cidr
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# create security
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
module "security" {
  source       = "../modules/security"
  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id

}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# create keypair
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

module "keypair" {
  source            = "../modules/keypair"
  keypair_algorithm = var.keypair_algorithm
  rsa_bit           = var.rsa_bit
  //keypair_name      = terraform.workspace=="dev"?"dev-keypair":terraform.workspace=="prod"?"prod-keypair":"stage-keypair"
  keypair_name      = terraform.workspace=="dev"?var.keypair_name:terraform.workspace=="prod"?var.keypair_name:var.keypair_name
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# create jenkins-server
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
module "jenkins-server" {
  source                           = "../modules/jenkins-server"
  instance_type                    = var.instance_type
  //keypair_name                     = terraform.workspace=="dev"?"dev-keypair":terraform.workspace=="prod"?"prod-keypair":"stage-keypair"
  keypair_name      = terraform.workspace=="dev"?var.keypair_name:terraform.workspace=="prod"?var.keypair_name:var.keypair_name
  public_subnet_az_id              = module.vpc.public_subnet_az_id
  project_name                     = var.project_name
  jenkins_server_security_group_id = [module.security.security_group_port_8080_id, module.security.security_group_port_22_id]
}



module "sonarqube-server" {
  source                             = "../modules/sonarqube-server"
  instance_type                      = var.instance_type
  //keypair_name                       = terraform.workspace=="dev"?"dev-keypair":terraform.workspace=="prod"?"prod-keypair":"stage-keypair"
  keypair_name      = terraform.workspace=="dev"?var.keypair_name:terraform.workspace=="prod"?var.keypair_name:var.keypair_name

  public_subnet_az_id                = module.vpc.public_subnet_az_id
  project_name                       = var.project_name
  sonarqube_server_security_group_id = [module.security.security_group_port_9000_id, module.security.security_group_port_22_id]
}

module "k8-server" {
  source                      = "../modules/k8-server"
  instance_type               = var.instance_type
  //keypair_name                = terraform.workspace=="dev"?"dev-keypair":terraform.workspace=="prod"?"prod-keypair":"stage-keypair"
  keypair_name      = terraform.workspace=="dev"?var.keypair_name:terraform.workspace=="prod"?var.keypair_name:var.keypair_name
  public_subnet_az_id         = module.vpc.public_subnet_az_id
  project_name                = var.project_name
  k8_server_security_group_id = [module.security.security_group_port_30000_id, module.security.security_group_port_22_id]
}

