#!/bin/bash

script_name=$0
Date=$(date +%F)
LOG_File=/tmp/$Date-$script_name.txt
USERID=$(id -u)

validate (){
if [[ $1 -ne 0 ]] ; then
    echo -e "\n Installation is failure. . .\n"
else
    echo -e "\n Installation is success. . .\n"
fi
}


if [[ $USERID -ne "0" ]] ; then
    echo "You need to be root user to perform this action, exiting . . ."
    exit 1
else
    echo "You have previlage to perform this action, continuing . . ."
fi

yum install mysql -y &>>$LOG_File
validate $? "Installing Mysql" &>>$LOG_File

yum install postfix -y &>>$LOG_File
validate $? "Installing Postfix" &>>$LOG_File