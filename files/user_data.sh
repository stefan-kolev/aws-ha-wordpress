#!/bin/bash
# echo "${var.efs_ip}:/ /var/www/html nfs defaults,vers=4.1 0 0" >> /etc/fstab
sudo hostnamectl set-hostname web.sdk.local
sudo apt update
sudo apt install -y apache2 \
                ghostscript \
                libapache2-mod-php \
                php \
                php-bcmath \
                php-curl \
                php-imagick \
                php-intl \
                php-json \
                php-mbstring \
                php-mysql \
                php-xml \
                php-zip \
                nfs-common
sudo mount -a
cd /tmp
wget https://www.wordpress.org/latest.tar.gz
sudo tar xzvf /tmp/latest.tar.gz --strip 1 -C /var/www/html
rm /tmp/latest.tar.gz
sudo chown -R www-data:www-data /var/www/html
sudo systemctl enable apache2
sudo tee /etc/apache2/sites-available/wordpress.conf &>/dev/null << EOF
<VirtualHost *:80>
    DocumentRoot /var/www/html
    <Directory /var/www/html>
        Options FollowSymLinks
        AllowOverride Limit Options FileInfo
        DirectoryIndex index.php
        Require all granted
    </Directory>
    <Directory /var/www/html/wp-content>
        Options FollowSymLinks
        Require all granted
    </Directory>
</VirtualHost>
EOF

sudo a2ensite wordpress
sudo a2enmod rewrite
sudo a2dissite 000-default
sudo service apache2 restart
