#!/bin/bash

set -euo pipefail

# ============================================================
# Configuration
# ============================================================

SONARQUBE_DIR="/home/ubuntu/sonarqube"
DOMAIN="sast.quanldl.uk"
LETSENCRYPT_EMAIL="ldlq2005@gmail.com"

export DEBIAN_FRONTEND=noninteractive

# ============================================================
# Install packages
# ============================================================

apt-get update
apt-get upgrade -y

apt-get install -y \
  docker.io \
  docker-compose \
  wget \
  openssl

# ============================================================
# Start Docker
# ============================================================

systemctl enable docker
systemctl start docker

# Allow ubuntu user to use Docker
usermod -aG docker ubuntu

# ============================================================
# SonarQube system requirements
# ============================================================

cat > /etc/sysctl.d/99-sonarqube.conf <<'EOF'
vm.max_map_count=524288
fs.file-max=131072
EOF

sysctl --system

# ============================================================
# Create directories
# ============================================================

mkdir -p "${SONARQUBE_DIR}"
mkdir -p "${SONARQUBE_DIR}/sonarqube_plugins"

chown -R ubuntu:ubuntu "${SONARQUBE_DIR}"

# ============================================================
# Generate random PostgreSQL password
# ============================================================

DB_PASSWORD="$(openssl rand -base64 32 | tr -dc 'A-Za-z0-9' | head -c 32)"

# ============================================================
# Create .env
# ============================================================

cat > "${SONARQUBE_DIR}/.env" <<EOF
POSTGRES_USER=sonar
POSTGRES_PASSWORD=${DB_PASSWORD}
POSTGRES_DB=sonar

SONAR_JDBC_USERNAME=sonar
SONAR_JDBC_PASSWORD=${DB_PASSWORD}

VIRTUAL_HOST=${DOMAIN}
VIRTUAL_PORT=9000

ACME_HOST=${DOMAIN}
ACME_EMAIL=${LETSENCRYPT_EMAIL}
EOF

chmod 600 "${SONARQUBE_DIR}/.env"
chown ubuntu:ubuntu "${SONARQUBE_DIR}/.env"

# ============================================================
# Create Docker Compose
# ============================================================

cat > "${SONARQUBE_DIR}/docker-compose.yml" <<'EOF'

services:

  # ==========================================================
  # Nginx Reverse Proxy
  # ==========================================================

  nginx-proxy:
    image: nginxproxy/nginx-proxy:latest
    container_name: nginx-proxy

    ports:
      - "80:80"
      - "443:443"

    volumes:
      - nginx_certs:/etc/nginx/certs
      - nginx_vhost:/etc/nginx/vhost.d
      - nginx_html:/usr/share/nginx/html
      - /var/run/docker.sock:/tmp/docker.sock:ro

    restart: unless-stopped


  # ==========================================================
  # Let's Encrypt
  # ==========================================================

  letsencrypt:
    image: nginxproxy/acme-companion:latest
    container_name: nginx-proxy-le

    depends_on:
      - nginx-proxy

    volumes:
      - nginx_certs:/etc/nginx/certs
      - nginx_vhost:/etc/nginx/vhost.d
      - nginx_html:/usr/share/nginx/html
      - acme_data:/etc/acme.sh
      - /var/run/docker.sock:/var/run/docker.sock:ro

    environment:
      NGINX_PROXY_CONTAINER: nginx-proxy
      DEFAULT_EMAIL: ${LETSENCRYPT_EMAIL}

    restart: unless-stopped


  # ==========================================================
  # SonarQube
  # ==========================================================

  sonarqube:
    image: sonarqube:community
    container_name: sonarqube

    depends_on:
      - db

    environment:
      SONAR_JDBC_URL: jdbc:postgresql://db:5432/sonar
      SONAR_JDBC_USERNAME: ${SONAR_JDBC_USERNAME}
      SONAR_JDBC_PASSWORD: ${SONAR_JDBC_PASSWORD}

      VIRTUAL_HOST: ${VIRTUAL_HOST}
      VIRTUAL_PORT: ${VIRTUAL_PORT}

      LETSENCRYPT_HOST: ${ACME_HOST}
      LETSENCRYPT_EMAIL: ${ACME_EMAIL}

    expose:
      - "9000"

    volumes:
      - sonarqube_data:/opt/sonarqube/data
      - sonarqube_extensions:/opt/sonarqube/extensions
      - sonarqube_logs:/opt/sonarqube/logs
      - ./sonarqube_plugins:/opt/sonarqube/extensions/plugins

    restart: unless-stopped


  # ==========================================================
  # PostgreSQL
  # ==========================================================

  db:
    image: postgres:15
    container_name: sonarqube_db

    environment:
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
      POSTGRES_DB: ${POSTGRES_DB}

    volumes:
      - postgresql:/var/lib/postgresql
      - postgresql_data:/var/lib/postgresql/data

    restart: unless-stopped


# ============================================================
# Volumes
# ============================================================

volumes:

  nginx_certs:
  nginx_vhost:
  nginx_html:
  acme_data:

  sonarqube_data:
  sonarqube_extensions:
  sonarqube_logs:

  postgresql:
  postgresql_data:

EOF

# ============================================================
# Download CNES Report Plugin
# ============================================================

wget \
  "https://github.com/cnescatlab/sonar-cnes-report/releases/download/5.0.4/sonar-cnes-report-5.0.4.jar" \
  -O "${SONARQUBE_DIR}/sonarqube_plugins/sonar-cnes-report-5.0.4.jar"

chown -R ubuntu:ubuntu "${SONARQUBE_DIR}"

# ============================================================
# Validate Docker Compose
# ============================================================

cd "${SONARQUBE_DIR}"

docker compose config

# ============================================================
# Start SonarQube stack
# ============================================================

docker compose up -d

# ============================================================
# Show status
# ============================================================

docker compose ps

echo "============================================================"
echo "SonarQube installation completed"
echo "Domain: https://${DOMAIN}"
echo "============================================================"