output "jenkins-server-public-ip" {
  value = module.jenkins-server.jenkins-server-public-ip

}

output "sonarqube-server-public-ip" {
  value = module.sonarqube-server.sonarqube-server-public-ip

}

output "k8-server-public-ip" {
  value = module.k8-server.k8-server-public-ip

}
