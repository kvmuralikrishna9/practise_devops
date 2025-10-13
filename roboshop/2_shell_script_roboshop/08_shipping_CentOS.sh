#!/bin/bash

# CentOS-8 Comes with MySQL 8 Version by default, However our application needs MySQL 5.7.

# AMI for CentOS: devops-practice ; ami-0b4f379183e5706b9 (user: centos //  password: DevOps321)

# Installing Maven
dnf install maven -y

# Create application user and application directory
useradd roboshop
mkdir /app

# Download the application code to app dierectory
curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip
cd /app
unzip /tmp/shipping.zip

# Build application from code
mvn clean package
mv target/shipping-1.0.jar /app/shipping.jar
cd 
# SystemD setup for shipping.service
cat << EOF > /etc/systemd/system/shipping.service
[Unit]
Description=Shipping Service

[Service]
User=roboshop
Environment=CART_ENDPOINT=cart.vrpproducts.shop:8080
Environment=DB_HOST=mysql.vrpproducts.shop
ExecStart=/bin/java -jar /app/shipping.jar
SyslogIdentifier=shipping

[Install]
WantedBy=multi-user.target
EOF

# Enable the shipping systemD service
systemctl daemon-reload
systemctl enable --now shipping

# Install mysql to load schema to Database
sudo dnf install mariadb105-server -y
systemctl enable --now mariadb.service

# Load schema
mysql -h mysql.vrpproducts.shop -uroot -pRoboShop@1 < /app/schema/shipping.sql #CentOS
mysql -h mysql.vrpproducts.shop -uroot -pRoboShop@1 < /app/db/schema.sql #AmazonLinux

mysql -h mysql.vrpproducts.shop -uroot -pRoboShop@1 < /app/db/app-user.sql
mysql -h mysql.vrpproducts.shop -uroot -pRoboShop@1 < /app/db/master-data.sql 

# Restart shipping systemD service
systemctl restart shipping.service