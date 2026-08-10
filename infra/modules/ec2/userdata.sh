#!/bin/bash

set -e
sudo apt update
sudo apt upgrade -y
sudo apt install -y docker.io docker-compose-plugin  wget
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker ubuntu
newgrp docker
mkdir -p /home/ubuntu/sonarqube
cat <<EOF > /home/ubuntu/sonarqube/docker-compose.yml

version: "3.8"

services:

  # Reverse Proxy

  nginx-proxy:
    image: nginxproxy/nginx-proxy:latest
    container_name: nginx-proxy

    labels:
      com.github.nginx-proxy.nginx: "true"

    ports:
      - "80:80"
      - "443:443"

    volumes:
      - /etc/nginx/certs:/etc/nginx/certs:rw
      - /etc/nginx/vhost.d:/etc/nginx/vhost.d
      - /usr/share/nginx/html:/usr/share/nginx/html
      - /var/run/docker.sock:/tmp/docker.sock:ro

    restart: unless-stopped

  # Let's Encrypt

  letsencrypt:
    image: nginxproxy/acme-companion:latest
    container_name: nginx-proxy-le

    depends_on:
      - nginx-proxy

    volumes:
      - /etc/nginx/certs:/etc/nginx/certs:rw
      - /etc/nginx/vhost.d:/etc/nginx/vhost.d
      - /usr/share/nginx/html:/usr/share/nginx/html
      - /var/run/docker.sock:/var/run/docker.sock:ro

    environment:
      NGINX_PROXY_CONTAINER: nginx-proxy
      DEFAULT_EMAIL: your-email@example.com

    restart: unless-stopped

  # SonarQube

  sonarqube:
    image: sonarqube:community
    container_name: sonarqube

    depends_on:
      - db

    environment:
      SONAR_JDBC_URL: jdbc:postgresql://db:5432/sonar
      SONAR_JDBC_USERNAME: sonar
      SONAR_JDBC_PASSWORD: sonar

      # nginx-proxy + Let's Encrypt
      VIRTUAL_HOST: sca.example.com
      LETSENCRYPT_HOST: sca.example.com
      LETSENCRYPT_EMAIL: your-email@example.com

    expose:
      - "9000"

    volumes:
      - sonarqube_data:/opt/sonarqube/data
      - sonarqube_extensions:/opt/sonarqube/extensions
      - sonarqube_logs:/opt/sonarqube/logs
      - ./sonarqube_plugins:/opt/sonarqube/extensions/plugins

    restart: unless-stopped

  # PostgreSQL

  db:
    image: postgres:15
    container_name: sonarqube_db

    environment:
      POSTGRES_USER: sonar
      POSTGRES_PASSWORD: sonar
      POSTGRES_DB: sonar

    volumes:
      - postgresql:/var/lib/postgresql
      - postgresql_data:/var/lib/postgresql/data

    restart: unless-stopped

volumes:
  sonarqube_data:
  sonarqube_extensions:
  sonarqube_logs:
  postgresql:
  postgresql_data:

EOF

sudo mkdir -p /home/ubuntu/sonarqube/sonarqube_plugins
cd /home/ubuntu/sonarqube/sonarqube_plugins
sudo wget \
https://github.com/cnescatlab/sonar-cnes-report/releases/download/5.0.4/sonar-cnes-report-5.0.4.jar \
-O /home/ubuntu/sonarqube/sonarqube_plugins/sonar-cnes-report-5.0.4.jar
cd /home/ubuntu/sonarqube
docker compose up -d
