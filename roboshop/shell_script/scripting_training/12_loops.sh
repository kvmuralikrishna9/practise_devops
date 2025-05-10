#!/bin/bash

#check the user is root 

LOG_DIR=/tmp/
SCRIPT_NAME=$0
DATE=$(date +%F)
LOG_FILE=$LOG_DIR/$SCRIPT_NAME_$DATE

USER_ID=$(id -u)
PACKAGES=("mysql" "postfix" "git")

if [[ $USER_ID -ne 0 ]] ; then
    echo -e "\nuser is not the 'root', use root user to continue. . ."
    exit 1
else
    eecho -e "\nuser is 'root', continuing to install the packages. . ."
fi

for i in $@ ; do
    yum list installed $i
    if [[ $? -ne 0 ]] ; then
        echo -e "$i is not installed,,"
        yum install $i -y
    else
        echo -e "$i is already installed,,"  
    fi
done



