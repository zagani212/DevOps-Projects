#! /bin/bash

sudo apt update -y

sudo apt install openjdk-21-jdk -y

echo 'export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64' >> ~/.bashrc
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.bashrc

source ~/.bashrc

sudo apt install maven -y