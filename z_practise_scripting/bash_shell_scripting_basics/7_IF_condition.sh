#!/bin/bash

# if [[ expresion with condition]] then
#     Execute or Print this
# else
#     Execute or Print this
# fi

echo "Please enter a number"
read number
echo "you enetered number: $number, please enter 'yes' to confirm"
read key
if [[ "$key" != yes ]] then
    echo "You not confimred with 'yes', so exiting"
    exit 1
fi

if [[ "$number" -gt 10 ]]; then
    echo "Entered number '$number' is greater than 10" 
else
    echo "Entered number '$number' is lesser than 10"
fi

sleep 1
echo "Thank you"