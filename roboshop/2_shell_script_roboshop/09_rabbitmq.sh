#!/bin/bash

# Configure RabbitMQ repo
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash

# Install RabbitMQ and enable the service
dnf install rabbitmq-server -y
systemctl enable --now rabbitmq-server.service

# Creating roboshop username and password for application in RabbitMQ
rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"

# Updating the Route53 record
PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

aws route53 change-resource-record-sets \
  --hosted-zone-id Z00742182642KBWUPN281 \
  --change-batch "{
    \"Changes\": [{
      \"Action\": \"UPSERT\",
      \"ResourceRecordSet\": {
        \"Name\": \"rabbitmq.vrpproducts.shop\",
        \"Type\": \"A\",
        \"TTL\": 0,
        \"ResourceRecords\": [{ \"Value\": \"$PRIVATE_IP\" }]
      }
    }]
  }" | tee -a $LOGFILE
echo -e "\nUpdated Private IP Address '$PRIVATE_IP' in A-records . . .\n" | tee -a $LOGFILE