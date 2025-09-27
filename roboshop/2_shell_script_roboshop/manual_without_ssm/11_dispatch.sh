#!/bin/bash

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
cat << EOF > /vim/systemd/system/dispatch.service
[Unit]
Description = Dispatch Service
[Service]
User=roboshop
Environment=AMQP_HOST=RABBITMQ-IP
Environment=AMQP_USER=roboshop
Environment=AMQP_PASS=roboshop123
ExecStart=/app/dispatch
SyslogIdentifier=dispatch

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now dispatch.service