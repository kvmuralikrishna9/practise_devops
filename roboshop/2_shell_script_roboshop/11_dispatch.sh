#!/bin/bash

set -e

# Checking the current user and suggest to be root
if [[ $USER -ne 0 ]] ; then
    echo "You have to be root to perform this operation"
    exit 1
fi

#Insyall Golanguage
dnf install golang -y

# Creating application user and app directory
useradd roboshop
mkdir /app

# Downloading application code, dependencies and installing 
curl -L -o /tmp/dispatch.zip https://roboshop-builds.s3.amazonaws.com/dispatch.zip
cd /app
unzip /tmp/dispatch.zip

go mod init dispatch
go get
go build

# Setup systemD service for dispatch3
cat << EOF > /etc/systemd/system/dispatch.service
[Unit]
Description = Dispatch Service
[Service]
User=roboshop
Environment=AMQP_HOST=rabbitmq.vrpproducts.shop
Environment=AMQP_USER=roboshop
Environment=AMQP_PASS=roboshop123
ExecStart=/app/dispatch
SyslogIdentifier=dispatch

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now dispatch.service

# Updating the Route53 record
PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

aws route53 change-resource-record-sets \
  --hosted-zone-id Z00742182642KBWUPN281 \
  --change-batch "{
    \"Changes\": [{
      \"Action\": \"UPSERT\",
      \"ResourceRecordSet\": {
        \"Name\": \"dispatch.vrpproducts.shop\",
        \"Type\": \"A\",
        \"TTL\": 0,
        \"ResourceRecords\": [{ \"Value\": \"$PRIVATE_IP\" }]
      }
    }]
  }" | tee -a $LOGFILE
echo -e "\nUpdated Private IP Address '$PRIVATE_IP' in A-records . . .\n" | tee -a $LOGFILE

# How to Verify Dispatch is Working (Functionally)
# sudo journalctl -u dispatch -f