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

scriptInfo "Provision-script: configure_php.sh, user: `whoami`"

# Nginx не содержит php, поэтому поставим php-fpm, чтобы потом настроить nginx отправлять php скрипты в php
# заодно установим пакет для работы с MySQL
scriptInfo "PHP-fpm installing ..."
sudo apt-get -y install php-fpm php-mysql
doneInfo

# идем править конфиги fpm чтобы нельзя было запускать любые найденные php файлы
# раскомментируем строчку cgi.fix_pathinfo и установим это значение в 0
scriptInfo "Setting cgi.fix_pathinfo ..."
sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php/7.0/fpm/php.ini
doneInfo

# перезапустим php
scriptInfo "PHP restarting ..."
sudo systemctl restart php7.0-fpm
doneInfo

# идем настраивать нгинкс, чтобы он использовал наш php процессор для динамического контента
# Включим index.php в обработку, причем раньше .html
scriptInfo "The index.php processing ..."
sed -i 's/index index.html index.htm index.nginx-debian.html;/index index.php index.html index.htm index.nginx-debian.html;/g' /etc/php/7.0/fpm/php.ini
doneInfo

# Зададим имя сервера как localhost, можно будет заменить на домен или ip сервера
scriptInfo "The server_name setting ..."
sed -i 's/server_name _;/server_name localhost;/g' /etc/php/7.0/fpm/php.ini


# Зададим настройки
scriptInfo "Other settings ..."
sed -i '/server_name localhost;/a\
location ~ \.php$ {\
include snippets/fastcgi-php.conf;\
fastcgi_pass unix:/run/php/php7.0-fpm.sock;\
}\
\
location ~ /\.ht {\
deny all;\
}
' /etc/nginx/sites-available/default
doneInfo

# Проверим правильность настроек
# sudo nginx -t


