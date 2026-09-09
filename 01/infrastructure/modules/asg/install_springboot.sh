#! /bin/bash

sudo apt update -y

sudo apt install openjdk-21-jdk -y

echo 'export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64' >> ~/.bashrc
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.bashrc

source ~/.bashrc

sudo apt install maven -y

git clone https://github.com/zagani212/DevOps-Projects.git
cd DevOps-Projects
git sparse-checkout init --cone
git sparse-checkout set 01/spring-boot-login-app/
cd 01/spring-boot-login-app
mvn clean package -DskipTests


cat <<'EOF' > /etc/systemd/system/java-login-app.service
[Unit]
Description=Java Login Spring Boot Application
After=network.target

[Service]
Type=simple

User=root
Group=root

WorkingDirectory=/DevOps-Projects/01/spring-boot-login-app

ExecStart=/usr/bin/java -jar /DevOps-Projects/01/spring-boot-login-app/target/login-app-1.0.0.jar

Restart=always
RestartSec=10

Environment="SPRING_PROFILES_ACTIVE=prod"

SuccessExitStatus=143

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable java-login-app
systemctl start java-login-app