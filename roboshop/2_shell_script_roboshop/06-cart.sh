#!/bin/bash

USERID=$(id -u)
APPDIR=/app

# Checking the current user and suggest to be root
if [[ $USER -ne 0 ]] ; then
    echo "You have to be root to perform this operation"
    exit 1
fi

# Adding Nodejs repo
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

# Installing NodeJS
dnf install nodejs -y

# Creating Application user
id roboshop &>/dev/null
CMD_STATUS=$?

if [[ $CMD_STATUS -ne 0 ]] ; then 
    echo -e "\nuser 'roboshop' not found, continuing creating the user\n" #| tee -a $LOGFILE
    useradd roboshop
else
    echo -e "\nuser 'roboshop' exits, so continuing without creating user\n" #| tee -a $LOGFILE
fi

# Creating app directory

if [[ ! -d $APPDIR ]] ; then
    echo -e "\napplication directory not found so creating" #&>> $LOGFILE
    mkdir /app
else
    echo -e "\napplication directory alreadt exists. . . continuing\n" #&>> $LOGFILE
fi

# Download and install the application code in app directory
cd /app 
curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip
unzip /tmp/cart.zip
npm install

# Created and Enable SystemD user Service
cat << EOF > /etc/systemd/system/cart.service
[Unit]
Description = Cart Service
[Service]
User=roboshop
Environment=REDIS_HOST=redis.vrpproducts.online
Environment=CATALOGUE_HOST=catalogue.vrpproducts.online
Environment=CATALOGUE_PORT=8080
ExecStart=/bin/node /app/server.js
SyslogIdentifier=cart

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now cart.service