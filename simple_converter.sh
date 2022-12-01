#!/bin/bash

echo "Enter a definition:"

read -a user_input

arr_length="${#user_input[@]}"
definition="${user_input[0]}"
constant="${user_input[1]}"

rs='[a-z]+_to_[a-z]+'
check_float='^[-,0-9,.]+$'
another_float_check='^[-,0-9,.]+$'

if [[ ("$arr_length" = 2) && ($definition =~ $rs) && ($constant =~ $check_float) ]]; then
    echo "Enter a value to convert:"
    read -a second_user_input

    while [[ ! $second_user_input =~ $another_float_check ]];
    do
        echo "Enter a float or integer value!"
        read -a second_user_input
    done

    echo "Result: $(echo "scale=2; $constant * $second_user_input" | bc -l)"
else
    echo "The definition is incorrect!"
fi