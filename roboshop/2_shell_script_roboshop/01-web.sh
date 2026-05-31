#!/bin/bash

USERID=$(id -u)
LOGFILE=/tmp/roboshop_ui_script.log

#set -e 

# Checking the current user and suggest to be root
if [[ $USERID -ne 0 ]] ; then
    echo -e "\nYou have to be root to perform this operation. . ." | tee -a $LOGFILE
    exit 1
fi

# Installing and Enable the Nginix servive
dnf install nginx -y | tee -a $LOGFILE
systemctl enable --now nginx.service | tee -a $LOGFILE
echo -e "\nInstalled and enabled the nginx and service . . .\n" | tee -a $LOGFILE

#Removing the Nginx default html files
rm -rf /usr/share/nginx/html/*

# Downloading the web configuraton files from url
cd /tmp
curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip | tee -a $LOGFILE
cd /usr/share/nginx/html
unzip /tmp/web.zip | tee -a $LOGFILE
echo -e "\nDownloaded web configuraton files . . .\n" | tee -a $LOGFILE

# Adding the proxy configuration file
cat <<EOF > /etc/nginx/default.d/roboshop.conf
proxy_http_version 1.1;
location /images/ {
  expires 5s;
  root   /usr/share/nginx/html;
  try_files \$uri /images/placeholder.jpg;
}
location /api/catalogue/ { proxy_pass http://catalogue.vrpproducts.shop:8080/; }
location /api/user/ { proxy_pass http://user.vrpproducts.shop:8080/; }
location /api/cart/ { proxy_pass http://cart.vrpproducts.shop:8080/; }
location /api/shipping/ { proxy_pass http://shipping.vrpproducts.shop:8080/; }
location /api/payment/ { proxy_pass http://payment.vrpproducts.shop:8080/; }

location /health {
  stub_status on;
  access_log off;
}
EOF
echo -e "\nAdded proxy configuration file . . .\n" | tee -a $LOGFILE

# Restarting the Nginx Service
systemctl restart nginx.service
echo -e "\nRestarted nginx.service . . .\n" | tee -a $LOGFILE

# Updating the Route53 record
PUBLIC_IP=$(curl -s http://checkip.amazonaws.com)

aws route53 change-resource-record-sets \
  --hosted-zone-id Z0733341RBXDY8DMJGHB \
  --change-batch "{
    \"Changes\": [{
      \"Action\": \"UPSERT\",
      \"ResourceRecordSet\": {
        \"Name\": \"ui.vrpproducts.shop\",
        \"Type\": \"A\",
        \"TTL\": 60,
        \"ResourceRecords\": [{ \"Value\": \"$PUBLIC_IP\" }]
      }
    }]
  }"
echo -e "\nUpdated Public IP Address '$PUBLIC_IP' in A-records . . .\n" | tee -a $LOGFILE
