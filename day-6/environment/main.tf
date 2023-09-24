
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# create VPC
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
module "vpc" {
  source                = "../modules/vpc"
  region                = terraform.workspace=="dev"?"us-east-1":terraform.workspace=="prod"?"us-east-2":"us-west-1"
  //region                = var.region
  project_name          = var.project_name
  vpc_cidr              = var.vpc_cidr
  public_subnet_az_cidr = var.public_subnet_az_cidr
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
  keypair_name      = terraform.workspace=="dev"?"dev-keypair":terraform.workspace=="prod"?"prod-keypair":"stage-keypair"
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# create jenkins-server
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
module "jenkins-server" {
  source                           = "../modules/jenkins-server"
  instance_type                    = var.instance_type
  keypair_name                     = terraform.workspace=="dev"?"dev-keypair":terraform.workspace=="prod"?"prod-keypair":"stage-keypair"
  public_subnet_az_id              = module.vpc.public_subnet_az_id
  project_name                     = var.project_name
  jenkins_server_security_group_id = [module.security.security_group_port_8080_id, module.security.security_group_port_22_id]
}



module "sonarqube-server" {
  source                             = "../modules/sonarqube-server"
  instance_type                      = var.instance_type
  keypair_name                       = terraform.workspace=="dev"?"dev-keypair":terraform.workspace=="prod"?"prod-keypair":"stage-keypair"
  public_subnet_az_id                = module.vpc.public_subnet_az_id
  project_name                       = var.project_name
  sonarqube_server_security_group_id = [module.security.security_group_port_9000_id, module.security.security_group_port_22_id]
}

module "k8-server" {
  source                      = "../modules/k8-server"
  instance_type               = var.instance_type
  keypair_name                = terraform.workspace=="dev"?"dev-keypair":terraform.workspace=="prod"?"prod-keypair":"stage-keypair"
  public_subnet_az_id         = module.vpc.public_subnet_az_id
  project_name                = var.project_name
  k8_server_security_group_id = [module.security.security_group_port_30000_id, module.security.security_group_port_22_id]
}

