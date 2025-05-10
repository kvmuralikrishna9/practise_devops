#!/bin/bash

USERID=$(id -u)

if [[ $USERID -ne "0" ]] ; then
    echo "You need to be root user to perform this action, exiting . . ."
    exit 1
else
    echo "You have previlage to perform this action, continuing . . ."
fi

yum install mysql -y

if [[ $? -ne 0 ]] ; then
    echo -e "\nmysql Installation failed...\n"
else
    echo -e "/nmysql installtion is sucess\n"
fi

yum install postfix -y

if [[ $? -ne 0 ]] ; then
    echo -e"\nPostfix Installation failed...\n"
else
    echo -e"\nPostfix installtion is sucess\n"
fi