# Development Workspace  variables and its default values
region_dev                = "us-east-1"
vpc_cidr_dev              = "192.168.0.0/16"
public_subnet_az_cidr_dev = "192.168.0.0/24"
keypair_name_dev          = "dev-keypair"

# Production Workspace variables and its default values
region_prod                = "us-east-2"
vpc_cidr_prod              = "192.162.0.0/16"
public_subnet_az_cidr_prod = "192.162.0.0/24"
keypair_name_prod          = "prod-keypair"

# Staging Workspace  variables and its default values
region_stage                = "us-west-1"
vpc_cidr_stage              = "192.100.0.0/16"
public_subnet_az_cidr_stage = "192.100.0.0/24"
keypair_name_stage          = "stage-keypair"


# Common varibales used in all workspaces and its default values
instance_type      = "t2.medium"
project_name       = "devOps"
keypair_algorithm  = "RSA"
rsa_bit            = 4096