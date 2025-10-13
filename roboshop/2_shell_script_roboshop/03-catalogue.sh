#!/bin/bash

USERID=$(id -u)
LOGFILE=/tmp/roboshop_catalogue_script.txt
APPDIR=/app


if [[ $USERID -ne 0 ]] ; then
    echo -e "\nYou have to be root to perform this operation . . .\n" | tee -a $LOGFILE
    exit 1
fi

# Setup NodeJS repos. Vendor is providing a script to setup the repos.
curl -sL https://rpm.nodesource.com/setup_lts.x | bash | tee -a $LOGFILE

# Installing NodeJS
dnf install nodejs -y | tee -a $LOGFILE

# Adding application user "roboshop"
id roboshop
CMD_STATUS=$?

if [[ $CMD_STATUS -ne 0 ]] ; then
    echo -e "\nuser 'roboshop' not found, continuing creating the user\n" | tee -a $LOGFILE
    useradd roboshop
else
    echo -e "\nuser 'roboshop' exits, so continuing without creating user\n" | tee -a $LOGFILE
fi

# Creating the application directory
if [[ ! -d "$APPDIR" ]] ; then
    echo -e "\napplication directory not found so creating\n" | tee -a $LOGFILE
    mkdir "$APPDIR"
else
    echo -e "\napplication directory already exists. . . continuing\n" | tee -a $LOGFILE
fi

# Download catalogue code to /tmp and unzip to app directory, and instaling dependencies
curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip  | tee -a $LOGFILE
cd /app
unzip /tmp/catalogue.zip  | tee -a $LOGFILE
npm install  | tee -a $LOGFILE
echo -e "\nInstalled dependencies\n"  | tee -a $LOGFILE

# Created and Enable SystemD Catalogue Service
cat <<EOF > /etc/systemd/system/catalogue.service
[Unit]
Description = Catalogue Service

[Service]
User=roboshop
Environment=MONGO=true
Environment=MONGO_URL="mongodb://mongodb.vrpproducts.shop:27017/catalogue"
ExecStart=/bin/node /app/server.js
SyslogIdentifier=catalogue

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload   
systemctl enable --now catalogue.service | tee -a $LOGFILE
echo -e "\nCreated and enabled SystemD catalogue.service . . .\n" | tee -a $LOGFILE

# To load schema we need to install mongodb client.
# To have it installed we can setup MongoDB repo and install mongodb-client

# Adding mongodb repo
cat << EOF > /etc/yum.repos.d/mongo.repo
[mongodb-org-7.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2023/mongodb-org/7.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://pgp.mongodb.com/server-7.0.asc
EOF

# installing mongodb-client
dnf install mongodb-mongosh -y | tee -a $LOGFILE
echo -e "\nInstalled mongodb" | tee -a $LOGFILE

# Load Schema
mongosh --host mongodb.vrpproducts.shop < /app/schema/catalogue.js  | tee -a $LOGFILE
CMD_STATUS=$?

if [[ $CMD_STATUS -ne 0 ]] ; then
    echo -e "\nOpenSSL issue,.. workiing with trouble shooting steps" | tee -a $LOGFILE
    dnf remove mongodb-mongosh -y  | tee -a $LOGFILE
    dnf install mongodb-mongosh-shared-openssl3 -y | tee -a $LOGFILE
    dnf install mongodb-mongosh -y | tee -a $LOGFILE
    mongosh --host mongodb.vrpproducts.shop < /app/schema/catalogue.js | tee -a $LOGFILE
    echo -e "\nLoad Scheme is successfull after troubleshooting. . .\n" | tee -a $LOGFILE 
else
    echo -e "\nLoad Scheme is successfull. . ." | tee -a $LOGFILE
fi

# Restart catalogue service
systemctl restart catalogue.service
echo -e "\nRestarted catalogue.service . . .\n" | tee -a $LOGFILE

# Updating the Route53 record
TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" \
      -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
PRIVATE_IP=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
      http://169.254.169.254/latest/meta-data/local-ipv4)

aws route53 change-resource-record-sets \
  --hosted-zone-id Z00742182642KBWUPN281 \
  --change-batch "{
    \"Changes\": [{
      \"Action\": \"UPSERT\",
      \"ResourceRecordSet\": {
        \"Name\": \"catalogue.vrpproducts.shop\",
        \"Type\": \"A\",
        \"TTL\": 0,
        \"ResourceRecords\": [{ \"Value\": \"$PRIVATE_IP\" }]
      }
    }]
  }"
echo -e "\nUpdated Private IP Address '$PRIVATE_IP' in A-records . . .\n" | tee -a $LOGFILE