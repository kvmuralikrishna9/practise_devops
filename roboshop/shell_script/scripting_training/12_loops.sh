#!/bin/bash

#check the user is root 

LOG_DIR=/tmp/
SCRIPT_NAME=$0
DATE=$(date +%F)
LOG_FILE=$LOG_DIR/$SCRIPT_NAME_$DATE

USER_ID=$(id -u)
PACKAGES=("mysql" "postfix" "git")

if [[ $USER_ID -ne 0 ]] ; then
    echo -e "\nuser is not the 'root', use root user to continue. . ." &2>>LOG_FILE
    exit 1
else
    echo -e "\nuser is 'root', continuing to install the packages. . ." &2>>LOG_FILE
fi

for i in $@ ; do
    yum list installed $i &2>>LOG_FILE
    if [[ $? -ne 0 ]] ; then
        echo -e "$i is not installed,," &2>>LOG_FILE
        yum install $i -y &2>>LOG_FILE
    else
        echo -e "$i is already installed,," &2>>LOG_FILE 
    fi
done



