#!/bin/bash

USERID=$(id -u)
APPDIR=/app
LOGFILE=/tmp/roboshop_user_script.log

set -e 

# Checking the current user and suggest to be root
if [[ $USER -ne 0 ]] ; then
    echo "You have to be root to perform this operation"
    exit 1
fi

# Adding Nodejs repo
curl -sL https://rpm.nodesource.com/setup_lts.x | bash |tee -a $LOGFILE

# Installing NodeJS
dnf install nodejs -y  |tee -a $LOGFILE
echo "Installed nodeJS . . . " |tee -a $LOGFILE

# Creating Application user
id roboshop 
CMD_STATUS=$?

if [[ $CMD_STATUS -ne 0 ]] ; then 
    echo -e "\nuser 'roboshop' not found, continuing creating the user\n" | tee -a $LOGFILE
    useradd roboshop
else
    echo -e "\nuser 'roboshop' exits, so continuing without creating user\n" | tee -a $LOGFILE
fi

# Creating app directory
if [[ ! -d $APPDIR ]] ; then
    echo -e "\napplication directory not found so creating" | tee -a $LOGFILE
    mkdir /app
else
    echo -e "\napplication directory alreadt exists. . . continuing\n" | tee -a $LOGFILE
fi

# Download and install the application code in app directory
cd /app
curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip | tee -a $LOGFILE
unzip /tmp/user.zip | tee -a $LOGFILE
npm install | tee -a $LOGFILE
echo -e "installed dependecies" | tee -a $LOGFILE

# Created and Enable SystemD user Service
cat << EOF > /etc/systemd/system/user.service
[Unit]
Description = User Service
[Service]
User=roboshop
Environment=MONGO=true
Environment=REDIS_HOST=redis.vrpproducts.shop
Environment=MONGO_URL="mongodb://mongodb.vrpproducts.shop:27017/users"
ExecStart=/bin/node /app/server.js
SyslogIdentifier=user

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload | tee -a $LOGFILE
systemctl enable --now user.service | tee -a $LOGFILE
echo -e "\nAdded systemD config file for user service" | tee -a $LOGFILE

################################################################################################

# Adding MongoDB repo and installing mongodb client
cat << EOF > /etc/yum.repos.d/mongo.repo
[mongodb-org-7.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2023/mongodb-org/7.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://pgp.mongodb.com/server-7.0.asc
EOF
dnf install mongodb-mongosh -y | tee -a $LOGFILE

# Load Schema
mongosh --host mongodb.vrpproducts.shop < /app/schema/user.js | tee -a $LOGFILE
CMD_STATUS=$?

if [[ $CMD_STATUS -ne 0 ]] ; then
    echo -e "\nOpenSSL issue,.. workiing with trouble shooting steps" | tee -a $LOGFILE
    dnf remove mongodb-mongosh -y | tee -a $LOGFILE
    dnf install mongodb-mongosh-shared-openssl3 -y | tee -a $LOGFILE
    dnf install mongodb-mongosh -y | tee -a $LOGFILE
    mongosh --host mongodb.vrpproducts.shop < /app/schema/user.js | tee -a $LOGFILE
    echo -e "\nLoad Scheme is successfull after troubleshooting. . ." | tee -a $LOGFILE
else
    echo -e "\nLoad Scheme is successfull. . ." | tee -a $LOGFILE
fi

# Restaring the user service
systemctl restart user.service | tee -a $LOGFILE

# Updating the Route53 record
PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

aws route53 change-resource-record-sets \
  --hosted-zone-id Z00742182642KBWUPN281 \
  --change-batch "{
    \"Changes\": [{
      \"Action\": \"UPSERT\",
      \"ResourceRecordSet\": {
        \"Name\": \"user.vrpproducts.shop\",
        \"Type\": \"A\",
        \"TTL\": 0,
        \"ResourceRecords\": [{ \"Value\": \"$PRIVATE_IP\" }]
      }
    }]
  }"
echo -e "\nUpdated Private IP Address '$PRIVATE_IP' in A-records . . .\n" | tee -a $LOGFILE