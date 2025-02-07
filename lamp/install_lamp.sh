#!/bin/bash

LOG_FILE="/var/log/lamp_setup.log"

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

install_lamp() {
    log "🚀 Installing LAMP Stack..."
    
    if [[ "$OS" == "ubuntu" ]]; then
        apt update -y
        apt install -y apache2 mysql-server php libapache2-mod-php php-mysql
        systemctl enable apache2
        systemctl start apache2
    elif [[ "$OS" == "centos" ]]; then
        yum install -y httpd mariadb-server php php-mysql
        systemctl enable httpd
        systemctl start httpd
    else
        log "❌ Unsupported OS!"
        exit 1
    fi

    log "✅ LAMP Stack Installed Successfully!"
}

install_lamp
