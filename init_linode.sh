# Refresh base packages
apt-get update
apt-get upgrade -y

# Set The Timezone
ln -sf /usr/share/zoneinfo/America/Vancouver /etc/localtime

# Create The Root SSH Directory If Necessary
if [ ! -d /root/.ssh ]
then
	mkdir -p /root/.ssh
	touch /root/.ssh/authorized_keys
fi

# Install NGINX
sudo apt-get install nginx

# Install MySQL
sudo apt-get install mysql-server
# Secure MYSQL (don't enable VALIDATE PASSWORD PLUGIN as it will break many common installers)
sudo mysql_secure_installation

# Install PHP
sudo apt-get install php-fpm php-mysql php-curl php-memcached php-mcrypt php-xml php-imagick

# Tweak Some PHP-FPM Settings
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.0/fpm/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.0/fpm/php.ini
sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.0/fpm/php.ini
sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.0/fpm/php.ini
sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.0/fpm/php.ini


# Install Composer Package Manager
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer


# Disable The Default Nginx Site
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
service nginx restart

# Open firewall settings for HTTP
sudo ufw allow 'Nginx HTTP'

# Verify firewall settings
sudo ufw status
