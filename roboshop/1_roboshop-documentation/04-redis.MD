# Redis 
Redis is used for in-memory data storage(Caching) and allows users to access the data of database over API.

### IF USING AMAZON LINUX 2023, install redis6 instead of simple redis

```
dnf install redis6 -y
```

### IF USING ANY OTHER OS PLEASE CHECK WILL REDIS IS SUPPOTED, 

Redis is offering the repo file as a rpm. Lets install it

```
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y

yum module enable redis:remi-6.2 -y

dnf install redis -y 
```

Usually Redis opens the port only to localhost(127.0.0.1), meaning this service can be accessed by the application that is hosted on this server only. However, we need to access this service to be accessed by another server, So we need to change the config accordingly.

Update listen address from 127.0.0.1 to 0.0.0.0 in /etc/redis.conf & /etc/redis/redis.conf

```
 vim /etc/redis6/redis6.conf
```

Start & Enable Redis Service

```
systemctl enable redis.service
```

```
systemctl start redis.service
```