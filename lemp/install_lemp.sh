#!/bin/bash

LOG_FILE="/var/log/lemp_setup.log"

# Function to log messages
log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') $1" | tee -a "$LOG_FILE"
}

# Check if the user is root
if [[ $EUID -ne 0 ]]; then
    log "❌ This script must be run as root!"
    exit 1
fi

# Detect OS
OS=""
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    log "❌ Unable to detect OS!"
    exit 1
fi

log "🔎 Detected OS: $OS"

install_lemp() {
    log "🚀 Installing LEMP Stack..."
    
    if [[ "$OS" == "ubuntu" ]]; then
        apt update -y
        apt install -y nginx mysql-server php-fpm php-mysql
        systemctl enable nginx
        systemctl start nginx
    elif [[ "$OS" == "centos" ]]; then
        yum install -y nginx mariadb-server php-fpm php-mysql
        systemctl enable nginx
        systemctl start nginx
    else
        log "❌ Unsupported OS!"
        exit 1
    fi

    log "✅ LEMP Stack Installed Successfully!"
}

install_lemp

