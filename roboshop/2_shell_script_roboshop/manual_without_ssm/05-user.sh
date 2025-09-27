#!/bin/bash

USERID=$(id -u)
APPDIR=/app
$SCRITP_NAME=$0
LOGFILE=/tmp/$SCRITP_NAME.txt


# Checking the current user and suggest to be root
if [[ $USER -ne 0 ]] ; then
    echo "You have to be root to perform this operation"
    exit 1
fi

# Adding Nodejs repo
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> LOGFILE

# Installing NodeJS
dnf install nodejs -y  &>> $LOGFILE
echo "Installed nodeJS . . . " |tee -a $LOGFILE

# Creating Application user
id roboshop &>/dev/null
CMD_STATUS=$?

if [[ $CMD_STATUS -ne 0 ]] ; then 
    echo -e "\nuser 'roboshop' not found, continuing creating the user\n" | tee -a $LOGFILE
    useradd roboshop
else
    echo -e "\nuser 'roboshop' exits, so continuing without creating user\n" | tee -a $LOGFILE
fi

# Creating app directory

if [[ ! -d $APPDIR ]] ; then
    echo -e "\napplication directory not found so creating" &>> $LOGFILE
    mkdir /app
else
    echo -e "\napplication directory alreadt exists. . . continuing\n" &>> $LOGFILE
fi

# Download and install the application code in app directory
cd /app
curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>> $LOGFILE
unzip /tmp/user.zip &>> $LOGFILE
npm install &>> $LOGFILE
echo -e "installed dependecies" | tee -a $LOGFILE

# Created and Enable SystemD user Service
cat << EOF > /etc/systemd/system/user.service
[Unit]
Description = User Service
[Service]
User=roboshop
Environment=MONGO=true
Environment=REDIS_HOST=redis.vrpproducts.online
Environment=MONGO_URL="mongodb://mongodb.vrpproducts.online:27017/users"
ExecStart=/bin/node /app/server.js
SyslogIdentifier=user

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload &>> $LOGFILE
systemctl enable --now user.service &>> $LOGFILE
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

dnf install mongodb-mongosh -y &>> $LOGFILE

# Load Schema

mongosh --host mongodb.vrpproducts.online < /app/schema/user.js &>> $LOGFILE
CMD_STATUS=$?

if [[ $CMD_STATUS -ne 0 ]] ; then
    echo -e "\nOpenSSL issue,.. workiing with trouble shooting steps" | tee -a $LOGFILE
    dnf remove mongodb-mongosh -y &>> $LOGFILE
    dnf install mongodb-mongosh-shared-openssl3 -y &>> $LOGFILE
    dnf install mongodb-mongosh -y &>> $LOGFILE
    mongosh --host mongodb.vrpproducts.online < /app/schema/user.js &>> $LOGFILE
    echo -e "\nLoad Scheme is successfull after troubleshooting. . ." | tee -a $LOGFILE
else
    echo -e "\nLoad Scheme is successfull. . ." | tee -a $LOGFILE
fi

# Restaring the user service
systemctl restart user.service &>> $LOGFILE