#!/bin/bash

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
mv target/shipping-1.0.jar shipping.jar

# SystemD setup for shipping.service
cat << EOF > /etc/systemd/system/shipping.service
[Unit]
Description=Shipping Service

[Service]
User=roboshop
Environment=CART_ENDPOINT=cart.vrpproducts.online:8080
Environment=DB_HOST=mysql.vrpproducts.online
ExecStart=/bin/java -jar /app/shipping.jar
SyslogIdentifier=shipping

[Install]
WantedBy=multi-user.target
EOF

# Enable the shipping systemD service
systemctl daemon-reload
systemctl enable --now shipping

# Install mysql to load schema to Database
dnf install mysql -y 

# Load schema
mysql -h mysql.vrpproducts.online -uroot -pRoboShop@1 < /app/schema/shipping.sql

# Restart shipping systemD service
systemctl restart shipping.service