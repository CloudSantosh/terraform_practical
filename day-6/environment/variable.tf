# Development Workspace  variables 
variable "region_dev" {}
variable "vpc_cidr_dev" {}
variable "public_subnet_az_cidr_dev" {}
variable "keypair_name_dev" {}

# Production Workspace variables
variable "region_prod" {}
variable "vpc_cidr_prod" {}
variable "public_subnet_az_cidr_prod" {}
variable "keypair_name_prod" {}

# Staging Workspace  variables
variable "region_stage" {}
variable "vpc_cidr_stage" {}
variable "public_subnet_az_cidr_stage" {}
variable "keypair_name_stage" {}

# Common varibales used in all workspaces
variable "instance_type" {}
variable "project_name" {}
variable "keypair_algorithm" {}
variable "rsa_bit" {}

/*
variable "region" {}
variable "project_name" {}
variable "vpc_cidr" {}
variable "public_subnet_az_cidr" {}
variable "instance_type" {}
variable "keypair_algorithm" {}
variable "keypair_name" {}
variable "rsa_bit" {}

*/