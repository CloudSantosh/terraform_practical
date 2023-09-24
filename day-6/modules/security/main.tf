#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#  create security group for 22 PORTS
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
resource "aws_security_group" "security_group_port_22" {
  name        = "server security group"
  description = "enable ssh access"
  vpc_id      = var.vpc_id

  ingress {
    description = "ssh access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "outbound access"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${terraform.workspace}-${var.project_name}-security_group_port_22"
  }
}
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#  create security group for Sonarqube-server WITH PORT 9000
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "security_group_port_9000" {
  name        = "sonarqube server security group"
  description = "enable PORT 9000"
  vpc_id      = var.vpc_id

  ingress {
    description = "port 9000 access"
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "outbound access"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${terraform.workspace}-${var.project_name}-security_group_port_9000"
  }
}



#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#  create security group for K8 Server
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "security_group_port_30000" {
  name        = "K8 server security group"
  description = "enable port access 30000"
  vpc_id      = var.vpc_id


  ingress {
    description = "port 30000 access"
    from_port   = 30000
    to_port     = 30000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "outbound access"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${terraform.workspace}-${var.project_name}-security_group_port_30000"
  }
}


#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#  create security group for port 8080
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "security_group_port_8080" {
  name        = "Jenkins server security group with port 8080"
  description = "enable port access 8080"
  vpc_id      = var.vpc_id


  ingress {
    description = "port 8080 access"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "outbound access"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${terraform.workspace}-${var.project_name}-security_group_port_8080"
  }
}
