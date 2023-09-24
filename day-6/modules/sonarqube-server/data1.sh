#!/bin/bash
# Increase the vm.max_map_count for kernel and ulimit for the current session at runtime.
sudo bash -c 'cat <<EOT> /etc/sysctl.conf
vm.max_map_count=524288
fs.file-max=131072
ulimit -n 65536
ulimit -u 4096
EOT'
sudo sysctl -w vm.max_map_count=524288
sysctl -w fs.file-max=131072

#Increase these permanently
sudo bash -c 'cat <<EOT> /etc/security/limits.conf
sonarqube   -   nofile   65536
sonarqube   -   nproc    4096
EOT'

# Need JDK 17 or higher to run SonarQube 9.9
sudo apt-get update -y
sudo apt-get install openjdk-17-jdk -y
sudo update-alternatives --config java
java -version

#Download the binaries for SonarQube 
sudo mkdir -p /sonarqube/
cd /sonarqube/
sudo curl -O https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.0.65466.zip
sudo apt-get install zip -y
sudo unzip -o sonarqube-9.9.0.65466.zip -d /opt/
sudo mv /opt/sonarqube-9.9.0.65466/ /opt/sonarqube
sudo rm -rf /opt/sonarqube/conf/sonar.properties
sudo touch /opt/sonarqube/conf/sonar.properties


# Create the group
sudo groupadd sonar
sudo useradd -c "SonarQube - User" -d /opt/sonarqube/ -g sonar sonar
sudo chown  -R sonar:sonar /opt/sonarqube/ 


# Create a systemd service file for SonarQube to run at system startup
sudo touch /etc/systemd/system/sonarqube.service
sudo bash -c 'cat <<EOT> /etc/systemd/system/sonarqube.service
[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking

ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop

User=sonar
Group=sonar
Restart=always

LimitNOFILE=65536
LimitNPROC=4096


[Install]
WantedBy=multi-user.target
EOT'

# automatically system startup enable
sudo systemctl daemon-reload
sudo systemctl enable sonarqube.service

# Automatically system startup enable
sudo systemctl restart sonarqube.service