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
    echo "mysql Installation failed..."
else
    echo "mysql installtion is sucess"
fi

yum install postfix -y

if [[ $? -ne 0 ]] ; sthen
    echo "Postfix Installation failed..."
else
    echo "Postfix installtion is sucess"
fi