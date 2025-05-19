#!/bin/bash

USERID=$(id -u)
LOGFILE=/tmp/output.txt
APPDIR=/app


if [[ $USERID -ne 0 ]] ; then
    echo -e "\nYou have to be root to perform this operation"
    exit 1
fi

# Setup NodeJS repos. Vendor is providing a script to setup the repos.
curl -sL https://rpm.nodesource.com/setup_lts.x | bash #&>> $LOGFILE

# Installing NodeJS
dnf install nodejs -y #&>> $LOGFILE

# Adding application user "roboshop"
id roboshop &>/dev/null
CMD_STATUS=$?

if [[ $CMD_STATUS -ne 0 ]] ; then
    echo -e "\nuser 'roboshop' not found, continuing creating the user\n" #| tee -a $LOGFILE
    useradd roboshop
else
    echo -e "\nuser 'roboshop' exits, so continuing without creating user\n" #| tee -a $LOGFILE
fi

# Creating the application directory
if [[ ! -d "$APPDIR" ]] ; then
    echo -e "\napplication directory not found so creating" #&>> $LOGFILE
    mkdir "$APPDIR"
else
    echo -e "\napplication directory alreadt exists. . . continuing\n" #&>> $LOGFILE 
fi

# Download catalogue code to /tmp and unzip to app directory, and instaling dependencies
curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip #&>> $LOGFILE
cd /app
unzip /tmp/catalogue.zip #&>> $LOGFILE
npm install #&>> $LOGFILE
echo -e "\nInstalled dependencies" #| tee -a $LOGFILE

# Created and Enable SystemD Catalogue Service
cat <<EOF > /etc/systemd/system/catalogue.service
[Unit]
Description = Catalogue Service

[Service]
User=roboshop
Environment=MONGO=true
Environment=MONGO_URL="mongodb://mongodb.vrpproducts.online:27017/catalogue"
ExecStart=/bin/node /app/server.js
SyslogIdentifier=catalogue

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload #&>> $LOGFILE    
systemctl enable --now catalogue.service #&>> $LOGFILE
echo -e "\nCretaed and Enable SystemD Catalogue Service" #| tee -a $LOGFILE

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
dnf install mongodb-mongosh -y #&>> $LOGFILE
echo -e "\nInstalled mongodb" #| tee -a $LOGFILE

# Load Schema
mongosh --host mongodb.vrpproducts.online < /app/schema/catalogue.js #&>> $LOGFILE
CMD_STATUS=$?

if [[ $CMD_STATUS -ne 0 ]] ; then
    echo -e "\nOpenSSL issue,.. workiing with trouble shooting steps" #| tee -a $LOGFILE
    dnf remove mongodb-mongosh -y #&>> $LOGFILE
    dnf install mongodb-mongosh-shared-openssl3 -y #&>> $LOGFILE
    dnf install mongodb-mongosh -y #&>> $LOGFILE
    mongosh --host mongodb.vrpproducts.online < /app/schema/catalogue.js #&>> $LOGFILE
    echo -e "\nLoad Scheme is successfull after troubleshooting. . ." #| tee -a $LOGFILE 
else
    echo -e "\nLoad Scheme is successfull. . ." #| tee -a $LOGFILE
fi

# Restart catalogue service
systemctl restart catalogue.service #&>> $LOGFILE
echo -e "\nRestared catalogue service" #| tee -a $LOGFILE