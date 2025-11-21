#!/bin/bash

USERID=$(id -u)
LOGFILE=/tmp/roboshop_redis6_script.log

set -e 

# Checking the current user and suggest to be root
if [[ $USERID -ne 0 ]] ; then
    echo "You have to be root to perform this operation"
    exit 1
fi

# Installing Redis6
dnf install redis6 -y | tee -a $LOGFILE

## Replacing the default local host 127.0.0.1 to 0.0.0.0
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis6/redis6.conf
CMD_STATUS=$?

if [[ $CMD_STATUS -ne 0 ]] ; then
    echo -e "\nReplace was failed. . . please review the config file" | tee -a $LOGFILE
else    
    echo -e "\nReplaced the default local host 127.0.0.1 to 0.0.0.0" | tee -a $LOGFILE
fi

# Start & Enable Redis Service
systemctl enable --now redis6.service | tee -a $LOGFILE

# Updating the Route53 record
TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
  
PRIVATE_IP=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/local-ipv4)

aws route53 change-resource-record-sets \
  --hosted-zone-id Z0733341RBXDY8DMJGHB \
  --change-batch "{
    \"Changes\": [{
      \"Action\": \"UPSERT\",
      \"ResourceRecordSet\": {
        \"Name\": \"redis6.vrpproducts.shop\",
        \"Type\": \"A\",
        \"TTL\": 0,
        \"ResourceRecords\": [{ \"Value\": \"$PRIVATE_IP\" }]
      }
    }]
  }" 

echo -e "\nUpdated Private IP Address '$PRIVATE_IP' in A-records . . .\n" | tee -a $LOGFILE