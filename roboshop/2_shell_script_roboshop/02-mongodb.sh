#!/bin/bash

USERID=$(id -u)
LOGFILE="/tmp/roboshop_mongodb_script.log"

set -e 

# Checking the current user and suggest to be root
if [[ $USERID -ne 0 ]] ; then
    echo -e "\nYou have to be root to perform this operation" | tee -a $LOGFILE
    exit 1
fi

# Creating Mongodb repository
cat <<EOF > /etc/yum.repos.d/mongo.repo
[mongodb-org-7.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2023/mongodb-org/7.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://pgp.mongodb.com/server-7.0.asc
EOF
echo -e "\nCreated Mongodb repository" | tee -a $LOGFILE

# Installing and Enable the mongodb service
dnf install mongodb-org -y | tee -a $LOGFILE
systemctl enable --now mongod.service | tee -a $LOGFILE
echo -e "\nInstalled and enabled mongodb and service" | tee -a $LOGFILE

# Replacing the default local host 127.0.0.1 to 0.0.0.0
sed -i 's/^ *bindIp:.*$/  bindIp: 0.0.0.0/' /etc/mongod.conf
CMD_STATUS=$?

if [[ $CMD_STATUS -ne 0 ]] ; then
    echo -e "\nReplace was failed. . . please review the config file" | tee -a $LOGFILE
else    
    echo -e "\nReplaced the default local host 127.0.0.1 to 0.0.0.0" | tee -a $LOGFILE
fi

# Restaring the mongodb service
systemctl restart mongod.service | tee -a $LOGFILE
echo -e "\nRestarted mongod.service . . .\n" | tee -a $LOGFILE

# Updating the Route53 record
PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv)

aws route53 change-resource-record-sets \
  --hosted-zone-id Z0733341RBXDY8DMJGHB \
  --change-batch "{
    \"Changes\": [{
      \"Action\": \"UPSERT\",
      \"ResourceRecordSet\": {
        \"Name\": \"mongodb.vrpproducts.shop\",
        \"Type\": \"A\",
        \"TTL\": 0,
        \"ResourceRecords\": [{ \"Value\": \"$PRIVATE_IP\" }]
      }
    }]
  }" | tee -a $LOGFILE
echo -e "\nUpdated Private IP Address '$PRIVATE_IP' in A-records . . .\n" | tee -a $LOGFILE