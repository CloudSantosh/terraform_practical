#!/bin/bash
#################################
# Author: Santosh
# Date: 5th-July-2023
# version 1
# This code install Sonarqube in the ubuntu instances
##################################
set -x
sudo apt update -y
sudo apt install openjdk-17-jre -y
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-10.1.0.73491.zip
sudo apt-get install unzip -y
unzip sonarqube-10.1.0.73491.zip 
sudo mv sonarqube-10.1.0.73491 sonarqube
cd /sonarqube/bin/linux-x86-64
./sonar.sh console

