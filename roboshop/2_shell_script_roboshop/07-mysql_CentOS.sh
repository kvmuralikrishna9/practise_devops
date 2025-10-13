#!/bin/bash

# CentOS-8 Comes with MySQL 8 Version by default, However our application needs MySQL 5.7.

# AMI for CentOS: devops-practice ; ami-0b4f379183e5706b9 (user: centos //  password: DevOps321)

# Disabling MySQL 8 version
yum module disable mysql -y 

# Creating mysql repo
cat << EOF > /etc/yum.repos.d/mysql.repo
[mysql]
name=MySQL 5.7 Community Server
baseurl=http://repo.mysql.com/yum/mysql-5.7-community/el/7/$basearch/
enabled=1
gpgcheck=0
EOF

# Installing mysql and enabling the service
yum install mysql-community-server -y
systemctl enable --now mysqld

# Changing default root password in order to start using the database service
mysql_secure_installation --set-root-pass RoboShop@1



sudo dnf install mariadb105-server -y
systemctl enable --now mariadb.service
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'RoboShop@1'; FLUSH PRIVILEGES;"
vim /etc/my.cnf.d/mariadb-server.cnf   
uncommnet line 37
mysql -uroot -pRoboShop@1