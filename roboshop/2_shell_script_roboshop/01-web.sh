#!/bin/bash
EC2_Public_IP=$(curl -s http://checkip.amazonaws.com)

# Installing and Enable the Nginix servive
dnf install nginx -y
systemctl enable --now nginx.service
echo -e "\nInstalled and enabled the nginx and service"

#Removing the Nginx default html files
rm -rf /usr/share/nginx/html/*

# Downloading the web configuraton files from url
curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip
cd /usr/share/nginx/html
unzip /tmp/web.zip
echo -e "\nDownloaded web configuraton files"

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
echo -e "\nAdded proxy configuration file"

# Updating the Route53 record
aws route53 change-resource-record-sets \
  --hosted-zone-id Z07402131DWW2QIEP7UZ8 \
  --change-batch "{
    \"Changes\": [{
      \"Action\": \"UPSERT\",
      \"ResourceRecordSet\": {
        \"Name\": \"ui.vrpproducts.shop\",
        \"Type\": \"A\",
        \"TTL\": 0,
        \"ResourceRecords\": [{ \"Value\": \"$MYIP\" }]
      }
    }]
  }"

# Restarting the Nginx Service
systemctl restart nginx.service
echo -n "\nRestarted nginx.service"