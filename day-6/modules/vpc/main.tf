#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#   Create VPC
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "${terraform.workspace}-${var.project_name}-vpc"
  }
}

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# create internet gateway and attach it to vpc
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${terraform.workspace}-${var.project_name}-igw"
  }
}

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#   use data source to get all avalablility zones in region
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
data "aws_availability_zones" "available_zones" {}



#------------------------------Public Subnets-----------------------------------------------
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# create public subnet az1
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
resource "aws_subnet" "public_subnet_az" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_az_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${terraform.workspace}-${var.project_name}-Public Subnet"
  }
}


#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#  create route table and add public route
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "${terraform.workspace}-${var.project_name}-Public Route Table"
  }
}

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# associate public subnet az1  to "public route table"
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
resource "aws_route_table_association" "public_subnet_az_route_table_association" {
  subnet_id      = aws_subnet.public_subnet_az.id
  route_table_id = aws_route_table.public_route_table.id
}
