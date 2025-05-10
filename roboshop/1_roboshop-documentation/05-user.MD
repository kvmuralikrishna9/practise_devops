# User

User is a microservice that is responsible for User Logins and Registrations Service in RobotShop e-commerce portal.

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
curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip
```

```
unzip /tmp/user.zip
```

Every application is developed by development team will have some common softwares that they use as libraries. This application also have the same way of defined dependencies in the application configuration.

Lets download the dependencies.

```
npm install 
```

We need to setup a new service in systemd so systemctl can manage this service

Setup SystemD User Service

```
vim /etc/systemd/system/user.service
```

```
[Unit]
Description = User Service
[Service]
User=roboshop
Environment=MONGO=true
Environment=REDIS_HOST=redis.vrpproducts.online
Environment=MONGO_URL="mongodb://mongodb.vrpproducts.online:27017/users"
ExecStart=/bin/node /app/server.js
SyslogIdentifier=user

[Install]
WantedBy=multi-user.target
```

Load the service.

```
systemctl daemon-reload
```

```
systemctl enable user.service
```
```
systemctl start user.service
```

For the application to work fully functional we need to load schema to the Database. Then

**NOTE: Schemas are usually part of application code and developer will provide them as part of development.**

We need to load the schema. To load schema we need to install mongodb client.

To have it installed we can setup MongoDB repo and install mongodb-client

```
vim /etc/yum.repos.d/mongo.repo
```

```
[mongodb-org-7.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2023/mongodb-org/7.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://pgp.mongodb.com/server-7.0.asc
```
```
dnf install mongodb-mongosh -y
```

Load Schema

```
mongosh --host mongodb.vrpproducts.online < /app/schema/user.js
```

NOTE: If we get openssl error, execute below and then do 'Load Schema'

```
yum remove mongodb-mongosh -y
yum install mongodb-mongosh-shared-openssl3 -y
yum install mongodb-mongosh -y
mongosh --host mongodb.vrpproducts.online < /app/schema/user.js
```

After Loading Schema, restart user service

```
systemctl restart user.service
```
