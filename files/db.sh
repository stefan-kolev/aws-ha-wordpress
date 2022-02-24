#!/bin/bash
sudo hostnamectl set-hostname db.sdk.local
sudo apt update -y
sudo apt install -y mariadb-server
sudo systemctl enable mariadb
sudo sed -i '/bind-address/d' /etc/mysql/mariadb.conf.d/50-server.cnf
sudo systemctl restart mariadb
source /tmp/dbpass
sudo mysql -Bse "CREATE DATABASE wordpress; CREATE USER wordpress@'%' IDENTIFIED BY '$db_password';GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,ALTER ON wordpress.* TO wordpress@'%'; FLUSH PRIVILEGES;"