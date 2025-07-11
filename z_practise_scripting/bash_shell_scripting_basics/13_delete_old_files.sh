#!/bin/bash

DELETE_LOGS_FROM=/var/log/
DATE=$(date +%F)
SCRIPT_NAME=$0
OUTPUT_LOG=/tmp/$SCRIPT_NAME-$DATE.log

FILES_TO_DELETE=$(find $DELETE_LOGS_FROM -name "*.log" -type f -mtime +14) &>>$OUTPUT_LOG

while read line ; do 
    echo  "Deleting the old files" &>>$OUTPUT_LOG
    rm -rf $line
done << $FILES_TO_DELETE
