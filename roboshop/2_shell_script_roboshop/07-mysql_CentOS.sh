# CentOS-8 Comes with MySQL 8 Version by default, However our application needs MySQL 5.7.

#!/bin/bash

LOGFILE=/tmp/sql_setup.log

set -e 

# Checking the current user and suggest to be root
if [[ $USER -ne 0 ]] ; then
    echo "You have to be root to perform this operation"
    exit 1
fi

# Install MySQL and enable service
dnf install mysql-server -y | tee -a $LOGFILE
systemctl enable --now mysqld.service | tee -a $LOGFILE

# Set bind-address safely
if [ -f /etc/my.cnf.d/mysql-server.cnf ]; then
  if ! grep -q "bind-address = 0.0.0.0" /etc/my.cnf.d/mysql-server.cnf; then
    echo "bind-address = 0.0.0.0" >> /etc/my.cnf.d/mysql-server.cnf
    echo "Added bind-address to mysql-server.cnf" | tee -a $LOGFILE
  fi
elif [ -f /etc/mysql/mysql.conf.d/mysqld.cnf ]; then
  if ! grep -q "bind-address = 0.0.0.0" /etc/mysql/mysql.conf.d/mysqld.cnf; then
    echo "bind-address = 0.0.0.0" >> /etc/mysql/mysql.conf.d/mysqld.cnf
    echo "Added bind-address to mysqld.cnf" | tee -a $LOGFILE
  fi
fi

systemctl restart mysqld.service 
echo -e "\nRestared mysqld service\n"  | tee -a $LOGFILE

# Wait until MySQL is ready
until mysql -uroot -e ";" 2>/dev/null; do
  echo "Waiting for MySQL to start..."
  sleep 5
done

# Login as root without password and set native password
echo -e "\nLogin as root without password and set native password"
sudo mysql <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'RoboShop@1';
FLUSH PRIVILEGES;
EOF

# Apply remote root access
cat <<EOF > /tmp/mysql_grants.sql
CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY 'RoboShop@1';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

export MYSQL_PWD='RoboShop@1'
mysql -uroot < /tmp/mysql_grants.sql
unset MYSQL_PWD
rm -f /tmp/mysql_grants.sql
echo "Remote root user created with full privileges" | tee -a $LOGFILE

# Updating the Route53 record
PRIVATE_IP=$(curl -s http://checkip.amazonaws.com)

aws route53 change-resource-record-sets \
  --hosted-zone-id Z0733341RBXDY8DMJGHB \
  --change-batch "{
    \"Changes\": [{
      \"Action\": \"UPSERT\",
      \"ResourceRecordSet\": {
        \"Name\": \"mysql.vrpproducts.shop\",
        \"Type\": \"A\",
        \"TTL\": 0,
        \"ResourceRecords\": [{ \"Value\": \"$PRIVATE_IP\" }]
      }
    }]
  }"
echo -e "\nUpdated Private IP Address '$PRIVATE_IP' in A-records . . .\n" | tee -a $LOGFILE

