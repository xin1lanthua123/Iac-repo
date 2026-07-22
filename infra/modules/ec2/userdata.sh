#!/bin/bash

apt update -y


apt install -y \
ca-certificates \
curl \
gnupg


install -m 0755 -d /etc/apt/keyrings


curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
| gpg --dearmor \
-o /etc/apt/keyrings/docker.gpg


echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" \
> /etc/apt/sources.list.d/docker.list


apt update -y


apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y



mkdir -p /opt/sonarqube


cat <<EOF > /opt/sonarqube/docker-compose.yml

version: "3"

services:

  sonarqube:

    image: sonarqube:lts-community

    container_name: sonarqube

    ports:
      - "9000:9000"


    environment:

      SONAR_ES_BOOTSTRAP_CHECKS_DISABLE: true


    volumes:

      - sonar_data:/opt/sonarqube/data

      - sonar_extensions:/opt/sonarqube/extensions

      - sonar_logs:/opt/sonarqube/logs


volumes:

  sonar_data:

  sonar_extensions:

  sonar_logs:

EOF



cd /opt/sonarqube


docker compose up -d