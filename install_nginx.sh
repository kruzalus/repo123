#!/usr/bin/env bash

# Helpers

function scriptInfo {
  echo "-->"
  echo "--> $1"
  echo "-->"
}

function actionInfo {
  echo -n "--> $1"
}

function doneInfo {
  echo "--> ...done"
}

# Provisioning

scriptInfo "Provision-script: install_nginx.sh, user: `whoami`"

actionInfo "Updating repositories"
sudo apt-get update
doneInfo

actionInfo "Install nginx"
DEBIAN_FRONTEND=noninteractive apt-get install -y nginx
doneInfo

if ! [ -L /var/www ]; then
  rm -rf /var/www
  ln -fs /vagrant /var/www
fi

# Настраиваем фаервол на работу с Nginx, пока только по HTTP
actionInfo "Setting up ufw 80"
sudo ufw allow 80
doneInfo

actionInfo "Setting up ufw HTTP"
sudo ufw allow 'Nginx HTTP'
doneInfo

# ХЗ что из этого лучше делать, но если не делать 22, то походу не залогиниться по SSH потом??
actionInfo "Setting up ufw 22"
sudo ufw allow 22
doneInfo

actionInfo "Setting up ufw OpenSSH"
sudo ufw allow 'OpenSSH'
doneInfo

# Включаем фаервол только после настройки
actionInfo "Enable ufw"
yes Y | sudo ufw enable
doneInfo