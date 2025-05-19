
#!/bin/bash

USERID=$(id -u)
LOGFILE=/tmp/output.txt

# Checking the current user and suggest to be root
if [[ $USER -ne 0 ]] ; then
    echo "You have to be root to perform this operation"
    exit 1
fi

# Installing and Enable the Nginix servive
dnf install nginx -y #&>> $LOGFILE
systemctl enable --now nginx.service #&>> $LOGFILE
echo -e "\nInstalled and enabled the nginx and service" #| tee -a $LOGFILE

#Removing the Nginx default html files
rm -rf /usr/share/nginx/html/*

# Downloading the web configuraton files from url
curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip #&>> $LOGFILE
cd /usr/share/nginx/html
unzip /tmp/web.zip #&>> $LOGFILE
echo -e "\nDownloaded web configuraton files" #| tee -a $LOGFILE

# Adding the proxy configuration file
cat <<EOF > /etc/nginx/default.d/roboshop.conf
proxy_http_version 1.1;
location /images/ {
  expires 5s;
  root   /usr/share/nginx/html;
  try_files \$uri /images/placeholder.jpg;
}
location /api/catalogue/ { proxy_pass http://catalogue.vrpproducts.online:8080/; }
location /api/user/ { proxy_pass http://user.vrpproducts.online:8080/; }
location /api/cart/ { proxy_pass http://cart.vrpproducts.online:8080/; }
location /api/shipping/ { proxy_pass http://shipping.vrpproducts.online:8080/; }
location /api/payment/ { proxy_pass http://payment.vrpproducts.online:8080/; }

location /health {
  stub_status on;
  access_log off;
}
EOF
echo -e "\nAdded proxy configuration file" #| tee -a $LOGFILE

# Restarting the Nginx Service
systemctl restart nginx.service #&>> $LOGFILE
echo -e "\nRestared Nginx service" #| tee -a $LOGFILE