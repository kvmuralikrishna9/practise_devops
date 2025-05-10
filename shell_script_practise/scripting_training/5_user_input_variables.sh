#!/bin/bash

echo "Please enter your First Name:"
read firstname
echo "Hello $firstname, Welcome to Devops training"
echo "Please enter your Last Name"
read lastname
echo "Thank you again for providing your last name"
echo "Just as validation your name is $lastname, $firstname"

echo "Please enter your password:"
read -s $password

echo -e "\nThis is your password: $password"