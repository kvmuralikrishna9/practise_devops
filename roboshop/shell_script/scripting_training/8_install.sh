#!/bin/bash

USERID=$(id -u)

if [[ $USERID -ne "0" ]] then
    echo "You need to be root user to perform this action, exiting . . ."
    exit 1
else
    echo "You have previlage to perform this action, continuing . . ."
fi

yum install git -y