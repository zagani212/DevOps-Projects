#! /bin/bash

apt update -y
apt install apache2 -y

git clone https://github.com/zagani212/DevOps-Projects.git

sudo cp -R /DevOps-Projects/02/html-web-app/* /var/www/html/