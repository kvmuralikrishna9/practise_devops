#!/bin/bash

USERID=$(id -u)
LOGFILE=/tmp/output.txt

# Checking the current user and suggest to be root
if [[ $USERID -ne 0 ]] ; then
    echo -e "\nYou have to be root to perform this operation"
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
dnf install mongodb-org -y &>> LOGFILE
systemctl enable --now mongod.service &>> LOGFILE
echo -e "\nInstalled and enabled mongodb and service" | tee -a $LOGFILE

# Replacing the default local host 127.0.0.1 to 0.0.0.0
sed -i '23 s/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
CMD_STATUS=$?

if [[ $CMD_STATUS -ne 0 ]] ; then
    echo -e "\nReplace was failed. . . please review the config file" | tee -a $LOGFILE
else    
    echo -e "\nReplaced the default local host 127.0.0.1 to 0.0.0.0" | tee -a $LOGFILE
fi

# Restaring the mongodb service
systemctl restart mongod.service | tee -a $LOGFILE