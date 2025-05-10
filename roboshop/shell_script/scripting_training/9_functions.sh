#!/bin/bash

USERID=$(id -u)

validate (){
if [[ $1 -ne 0 ]] ; then
    echo -e "\n Installation is failure. . . "
else
    echo -e "\n Installation is success. . . "
fi
}


if [[ $USERID -ne "0" ]] ; then
    echo "You need to be root user to perform this action, exiting . . ."
    exit 1
else
    echo "You have previlage to perform this action, continuing . . ."
fi

yum install mysql -y
validate $?

yum install postfix -y
validate $?