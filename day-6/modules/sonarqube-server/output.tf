output "sonarqube-server-public-ip" {
  value = aws_instance.sonarqube-server.public_ip

}
