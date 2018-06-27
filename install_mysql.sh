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

scriptInfo "Provision-script: install_mysql.sh, user: `whoami`"

actionInfo "Updating repositories"
sudo apt-get update
doneInfo

actionInfo "Install mysql"
## sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password '
## sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password '
## DEBIAN_FRONTEND=noninteractive sudo apt-get -y install mysql-server
# debconf-set-selections <<< 'mariadb-server mysql-server/root_password password '
# debconf-set-selections <<< 'mariadb-server mysql-server/root_password_again password '
# DEBIAN_FRONTEND=noninteractive apt-get install -y mariadb-server-10.0
debconf-set-selections <<< 'mysql-server mysql-server/root_password password '
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password '
DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server
doneInfo

actionInfo "Configure MySQL"
sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/my.cnf
doneInfo

actionInfo "Configure root user"
# mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '' WITH GRANT OPTION; FLUSH PRIVILEGES;"
doneInfo

# можно после этого установить левел валидации паролей или не устанавливать, на все остальное можно отвечать Y
# y | mysql_secure_installation