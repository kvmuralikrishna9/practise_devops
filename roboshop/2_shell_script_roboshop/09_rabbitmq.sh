#!/bin/bash

# Configure RabbitMQ repo
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash

# Install RabbitMQ and enable the service
dnf install rabbitmq-server -y
systemctl enable --now rabbitmq-server.service

# Creating roboshop username and password for application in RabbitMQ
rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"