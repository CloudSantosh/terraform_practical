output "k8-server-public-ip" {
  value = aws_instance.k8-server.public_ip
}
