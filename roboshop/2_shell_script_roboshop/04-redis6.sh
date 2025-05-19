#!/bin/bash

SCRITP_NAME=$0
LOGFILE=/tmp/$SCRITP_NAME.txt


# Checking the current user and suggest to be root
if [[ $USER -ne 0 ]] ; then
    echo "You have to be root to perform this operation"
    exit 1
fi

# Installing Redis6
dnf install redis6 -y &>> LOGFILE

## Replacing the default local host 127.0.0.1 to 0.0.0.0
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis6/redis6.conf
CMD_STATUS=$?

if [[ $CMD_STATUS -ne 0 ]] ; then
    echo -e "\nReplace was failed. . . please review the config file" #| tee -a $LOGFILE
else    
    echo -e "\nReplaced the default local host 127.0.0.1 to 0.0.0.0" #| tee -a $LOGFILE
fi

# Start & Enable Redis Service
systemctl enable --now redis6.service &>> LOGFILE