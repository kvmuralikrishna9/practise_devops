### Cart
Cart is a microservice that is responsible for Cart Service in RobotShop e-commerce portal.

Setup NodeJS repos. Vendor is providing a script to setup the repos.

```
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
```
Install NodeJS

```
dnf install nodejs -y
```

Configure the application.

Add application User

```
useradd roboshop
```

Lets setup an app directory.

```
mkdir /app
```

```
cd /app 
```

Download the application code to created app directory.

```
curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip
```

```
unzip /tmp/cart.zip
```

Every application is developed by development team will have some common softwares that they use as libraries. This application also have the same way of defined dependencies in the application configuration.

Lets download the dependencies. 

```
npm install 
```
Note: While installing dependencies, If we see depricated dependencied error, we can ignore

We need to setup a new service in systemd so systemctl can manage this service

Setup SystemD Cart Service

```
vim /etc/systemd/system/cart.service
```

```
[Unit]
Description = Cart Service
[Service]
User=roboshop
Environment=REDIS_HOST=redis.vrpproducts.online
Environment=CATALOGUE_HOST=catalogue.vrpproducts.online
Environment=CATALOGUE_PORT=8080
ExecStart=/bin/node /app/server.js
SyslogIdentifier=cart

[Install]
WantedBy=multi-user.target
```

Load the service.

```
systemctl daemon-reload
```

```
systemctl enable cart.service
```
```
systemctl start cart.service
```