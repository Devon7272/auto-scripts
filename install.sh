#!/bin/bash

[ "$EUID" -eq 0 ] || {
  echo 'please run with sudo or as root.'
  exit 1
}

# Install Apache, PHP, amd PHP Modules
yum install -y httpd php php-mysql

# Start and enable the webserver
sudo systemctl start httpd
sudo systemctl enable httpd

# Install MariaDB
yum install -y mariadb-server

# Start and enable mariadb
systemctl start mariadb
systemctl enable mariadb

# Create wordpress database
mysqladmin create wordpress

# Create a user for the wordpress database
mysql -e "GRANT ALL on wordpress.* to wordpress@localhost identified by 'wordpress123';"
mysql -e "FLUSH PRIVILEGES;"

# Remove the test DB privileges.
mysql -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%'"
# Drop the test DB.
mysqladmin drop -f test
# Remove anonymous DB users.
mysql -e "DELETE FROM mysql.user WHERE User='';"
# Remove remote root DB account access.
mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN
('localhost', '127.0.0.1', '::1');"
# Set a root DB password
mysql -e "UPDATE mysql.user SET Password=PASSWORD('rootpassword123') WHERE User='root';"
# Flush the privileges
mysql -e "FLUSH PRIVILEGES;"

# Download and extract WordPress
TMP_DIR=$(mktemp -d)
cd $TMP_DIR
curl -sOL https://wordpress.org/latest.tar.gz
tar zxf latest.tar.gz
mv wordpress/* /var/www/html

# Clean up
cd /
rm -rf $TMP_DIR

# Install the wp-cli tool
curl -sOL https://raw.github.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp
chmod 755 /usr/local/bin/wp

# Configure wordpress
cd /var/www/html
/usr/local/bin/wp core config --dbname=wordpress --dbuser=wordpress \
--dbpass=wordpress123

# Install wordpress
/usr/local/bin/wp core install --url=http://10.23.45.60 \
--title="Blog" --admin_user="admin" --admin_password="admin" \
--admin_email="vagrant@localhost.localdomain"
