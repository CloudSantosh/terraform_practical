# Terraform: Modules and Workspaces
Terraform is an infrastructure provisioning tool. At its core, you define a declarative manifest of resources that represent concrete computing instances, system configuration such as networks, firewalls, and infrastructure configuration. Terraform adheres to the concept of immutable infrastructure: Resources should match the state as expressed in the manifests, and any difference between the concrete objects and the manifests are resolved by changing the conrete object or recreate it.

When Terraform projects grow, so does the complexity of managing reusable manifests and propper configuration. To help with this, two concepts can be used: Workspaces and modules. In a nutshell, workspaces encapsulate configuration and state for the same manifests, and modules encapsulate parametrized manifests that are grouped together to create connected infrastructure objects. This article explains workspaces and modules in detail, and will also help you to understand when, and when not to use, these concepts.


# Workspaces
A workspace is similar to a namespace: It has a dedicted name and an encapsualted state. In any Terraform project, the workspace that you start with is refered as the default workspace. The Terraform CLI than offers the following operations to manipulate workspaces:

- workspace new: Creates a new workspace
- workspace show: Shows the currently active workspace
- workspace list: Shows all availabke workspaces
- workspace select: Switch to a new workspace
- workspace delete: Delete a workspace

Workspaces should be used to provide multiple instances of a single configuration. This means that you want to reuse the very same manifests to create the vers samy resources, but provide a different configuration for these resources, for example to use a different image for a cloud server.

# Modules
Terraform modules provide coherent sets of parameterized resource descriptions. They are used to group related resource definitions to define architectural abstractions in your project, for example defining a control plane node with dedicated servers, VPC and databases.

Modules can be defined locally or used from a private or public registry. They are fully self-contained, they need to explicitly define their providers, their variables, and the resources.

## Example
As before, to better understand modules, let’s use them in the very same example project. We will create two separate modules for the Jenkins-server, Kubernetes server, sonarqube server, keypair, security and vpc and define them in such a way that all required variables are to passed from root modules.

### Create workspaces in the beginning 
    terraform workspace new dev
    terraform workspace new prod
    terraform workspace new stage

<img src="https://github.com/CloudSantosh/terraform_practical/blob/master/day-6/images/3.png" width="600" height="100">

### Create the modules directories and modules files. 
<img src="https://github.com/CloudSantosh/terraform_practical/blob/master/day-6/images/2.png" width="600" height="100">


### In the provider.tf, we need to provide following configuration 
``` 
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
  region  = terraform.workspace=="dev"?var.region_dev:terraform.workspace=="prod"?var.region_prod:var.region_stage
  profile = terraform.workspace
}

```

### In the terraform.tfvars, we need to provide values for the variables for root modules main.tf 
``` 
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

``` 

### variable.tf for the main.tf root modules
``` 
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


``` 
### In the main.tf in root modules, we define in the following way.
```

#-------------------
# create VPC
#-------------------
module "vpc" {
  source                = "../modules/vpc"
  region                = terraform.workspace=="dev"?var.region_dev:terraform.workspace=="prod"?var.region_prod:var.region_stage
  project_name          = var.project_name
  vpc_cidr              = terraform.workspace=="dev"?var.vpc_cidr_dev:terraform.workspace=="prod"?var.vpc_cidr_prod:var.vpc_cidr_stage
  public_subnet_az_cidr = terraform.workspace=="dev"?var.public_subnet_az_cidr_dev:terraform.workspace=="prod"?var.public_subnet_az_cidr_prod:var.public_subnet_az_cidr_stage 
}

#-------------------
# create security
#-------------------
module "security" {
  source       = "../modules/security"
  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id

}

#-------------------
# create keypair
#-------------------
module "keypair" {
  source            = "../modules/keypair"
  keypair_algorithm = var.keypair_algorithm
  rsa_bit           = var.rsa_bit
  keypair_name      = terraform.workspace=="dev"?var.keypair_name_dev:terraform.workspace=="prod"?var.keypair_name_prod:var.keypair_name_stage
}
#-------------------
# create jenkins-server
#-------------------
module "jenkins-server" {
  source              = "../modules/jenkins-server"
  instance_type       = var.instance_type
  keypair_name        = terraform.workspace=="dev"?var.keypair_name_dev:terraform.workspace=="prod"?var.keypair_name_prod:var.keypair_name_stage
  public_subnet_az_id = module.vpc.public_subnet_az_id
  project_name        = var.project_name
  jenkins_server_security_group_id = [module.security.security_group_port_8080_id, module.security.security_group_port_22_id]
}
#-------------------
# create Sonarqube-server
#-------------------
module "sonarqube-server" {
  source                = "../modules/sonarqube-server"
  instance_type         = var.instance_type
  keypair_name          = terraform.workspace=="dev"?var.keypair_name_dev:terraform.workspace=="prod"?var.keypair_name_prod:var.keypair_name_stage
  public_subnet_az_id   = module.vpc.public_subnet_az_id
  project_name          = var.project_name
  sonarqube_server_security_group_id = [module.security.security_group_port_9000_id, module.security.security_group_port_22_id]
}
#-------------------
# create Kubernetes-server
#-------------------
module "k8-server" {
  source                 = "../modules/k8-server"
  instance_type          = var.instance_type
  keypair_name           = terraform.workspace=="dev"?var.keypair_name_dev:terraform.workspace=="prod"?var.keypair_name_prod:var.keypair_name_stage
  public_subnet_az_id    = module.vpc.public_subnet_az_id
  project_name           = var.project_name
  k8_server_security_group_id = [module.security.security_group_port_30000_id, module.security.security_group_port_22_id]
}
```
When terraform validate reports no errors, you then need to run init again so that Terraform will configure the modules. Then, we can plan and apply the changes but before that we need to select the workspace before plan and apply the changes. The code for modules and root modules are same but when select the the workspaces running following command, 
    terraform workspace select <workspace_name>
    i.e. in our example, we have prod, dev and stage as workspace_name

## Conclusion
We learned about Terraform workspaces and modules, two methods that help to work with more complex projects. Following an example for creating cloud computing server in the AWS cloud, you saw both methods applied. In essence, workspaces provide namespaces for resource creation with dedicated states.
<img src="https://github.com/CloudSantosh/terraform_practical/blob/master/day-6/images/1.png" width="600" height="100">
Use them when you want to manage basically the same resource, but with different configuration, such as in a staging, production and development environment. Modules are fully self-contained, grouped resource definitions that represent parts of a complex infrastructure. Use them to separate your projects into logically related parts, such as a module for creating the resources in the environment, one for its nodes, and others. To better understand how workspaces and modules are used, this project also showed an example for seperating development, production and staging resources.




