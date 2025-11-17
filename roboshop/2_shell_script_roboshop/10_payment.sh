#!/bin/bash

set -e 

# Checking the current user and suggest to be root
if [[ $USER -ne 0 ]] ; then
    echo "You have to be root to perform this operation"
    exit 1
fi

#Install Python3.6
dnf install python3 python3-pip gcc python3-devel -y

# Creating Roboshop user and app directory
useradd roboshop
mkdir /app

# Downloadng application code, dependencies and installing 
curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip
cd /app
unzip /tmp/payment.zip
pip3 install -r requirements.txt

# Setup systemD service for payment service
cat <<'EOF' > /etc/systemd/system/payment.service
[Unit]
Description=Payment Service

[Service]
User=root
WorkingDirectory=/app
Environment=CART_HOST=cart.vrpproducts.shop
Environment=CART_PORT=8080
Environment=USER_HOST=user.vrpproducts.shop
Environment=USER_PORT=8080
Environment=AMQP_HOST=rabbitmq.vrpproducts.shop
Environment=AMQP_USER=roboshop
Environment=AMQP_PASS=roboshop123

ExecStart=/usr/local/bin/uwsgi --ini payment.ini
ExecStop=/bin/kill -9 $MAINPID
SyslogIdentifier=payment

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now payment.service

# Updating the Route53 record
PRIVATE_IP=$(curl -s http://checkip.amazonaws.com)

aws route53 change-resource-record-sets \
  --hosted-zone-id Z0733341RBXDY8DMJGHB \
  --change-batch "{
    \"Changes\": [{
      \"Action\": \"UPSERT\",
      \"ResourceRecordSet\": {
        \"Name\": \"payment.vrpproducts.shop\",
        \"Type\": \"A\",
        \"TTL\": 0,
        \"ResourceRecords\": [{ \"Value\": \"$PRIVATE_IP\" }]
      }
    }]
  }"
echo -e "\nUpdated Private IP Address '$PRIVATE_IP' in A-records . . .\n" | tee -a $LOGFILE