#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Create a key with RSA algorithm with 4096 rsa bits
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

resource "tls_private_key" "private_key" {
  algorithm = var.keypair_algorithm
  rsa_bits  = var.rsa_bit
}

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#create a key pair using above private key
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

resource "aws_key_pair" "keypair" {
  key_name   = var.keypair_name
  public_key = tls_private_key.private_key.public_key_openssh
  depends_on = [tls_private_key.private_key]
}

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# saving the private key at the specific location
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

resource "local_file" "save-key" {
  content = tls_private_key.private_key.private_key_pem
  //path.module is the module that access current working directory
  filename        = "${path.module}/${var.keypair_name}.pem"
  file_permission = "0400"
  # changes the file permission to read-only mode
  //provisioner "local-exec" {

  //command = "chmod 400 ${path.module}/${var.keypair-name}.pem"
  depends_on = [tls_private_key.private_key]

}

