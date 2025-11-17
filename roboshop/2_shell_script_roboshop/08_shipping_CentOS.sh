# CentOS-8 Comes with MySQL 8 Version by default, However our application needs MySQL 5.7.

#!/bin/bash

LOGFILE=/tmp/sql_setup.log

set -e

# Checking the current user and suggest to be root
if [[ $USER -ne 0 ]] ; then
    echo "You have to be root to perform this operation"
    exit 1
fi

# Installing Maven
dnf install maven -y | tee -a $LOGFILE

# Create application user and application directory
useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
mkdir /app

# Download the application code to app dierectory
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping-v3.zip | tee -a $LOGFILE
cd /app
unzip /tmp/shipping.zip | tee -a $LOGFILE

# Build application from code
mvn clean package | tee -a $LOGFILE
mv target/shipping-1.0.jar /app/shipping.jar

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
echo -e "\nCreated shipping systemD service file\n" | tee -a $LOGFILE

# Enable the shipping systemD service
systemctl daemon-reload
systemctl enable --now shipping.service
echo -e "Enabled shipping service\n" | tee -a $LOGFILE

# Install mysql to load schema to Database
dnf install mysql -y | tee -a $LOGFILE

# Set bind-address safely
if [ -f /etc/my.cnf.d/mysql-server.cnf ]; then
  if ! grep -q "bind-address = 0.0.0.0" /etc/my.cnf.d/mysql-server.cnf; then
    echo "bind-address = 0.0.0.0" >> /etc/my.cnf.d/mysql-server.cnf
    echo -e "Added bind-address to mysql-server.cnf\n" | tee -a $LOGFILE
  fi
elif [ -f /etc/mysql/mysql.conf.d/mysqld.cnf ]; then
  if ! grep -q "bind-address = 0.0.0.0" /etc/mysql/mysql.conf.d/mysqld.cnf; then
    echo "bind-address = 0.0.0.0" >> /etc/mysql/mysql.conf.d/mysqld.cnf
    echo -e "Added bind-address to mysqld.cnf\n" | tee -a $LOGFILE
  fi
fi

# Load schema
echo -e "\nAdding "/app/db/schema.sql" to SQL Server" | tee -a $LOGFILE
mysql -h mysql.vrpproducts.shop -uroot -pRoboShop@1 < /app/db/schema.sql
echo "Added "\n/app/db/schema.sql" to SQL Server" | tee -a $LOGFILE

echo -e "\nAdding "/app/db/app-user.sql" to SQL Server" | tee -a $LOGFILE
mysql -h mysql.vrpproducts.shop -uroot -pRoboShop@1 < /app/db/app-user.sql
echo "Adding "/app/db/app-user.sql" to SQL Server" | tee -a $LOGFILE

echo -e "\nAdding "/app/db/master-data.sql" to SQL Server" | tee -a $LOGFILE
mysql -h mysql.vrpproducts.shop -uroot -pRoboShop@1 < /app/db/master-data.sql
echo "Adding "/app/db/master-data.sql" to SQL Server" | tee -a $LOGFILE

# Restart shipping systemD service
systemctl restart shipping.service
echo -e "\nRestarted shipping service" | tee -a $LOGFILE

# Updating the Route53 record
PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv)

aws route53 change-resource-record-sets \
  --hosted-zone-id Z0733341RBXDY8DMJGHB \
  --change-batch "{
    \"Changes\": [{
      \"Action\": \"UPSERT\",
      \"ResourceRecordSet\": {
        \"Name\": \"shipping.vrpproducts.shop\",
        \"Type\": \"A\",
        \"TTL\": 0,
        \"ResourceRecords\": [{ \"Value\": \"$PRIVATE_IP\" }]
      }
    }]
  }"
echo -e "Updated Private IP Address '$PRIVATE_IP' in A-records . . ." | tee -a $LOGFILE