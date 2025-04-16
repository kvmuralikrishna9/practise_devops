#!/bin/bash

# This is example file for using array in shell script

user_name=("Murali" "Himanish" "Swarna")

echo -e "hello all, we have the ${user_name[1]} with us.\n"
echo -e "we also present you the ${user_name[2]} to teach devops\n"
echo "we all ${user_name[@]} to present the meeting"