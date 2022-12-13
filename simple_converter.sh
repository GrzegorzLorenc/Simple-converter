#!/bin/bash

echo "Welcome to the Simple converter!"
touch definitions.txt
file_name="definitions.txt"
line_amount="$(sed -n '$=' "$file_name")"
check_float='^[-,0-9,.]+$'
rs='[a-z]+_to_[a-z]+'

function menu() {
printf '%s\n' \
"Select an option" \
"0. Type '0' or 'quit' to end program" \
"1. Convert units" \
"2. Add a definition" \
"3. Delete a definition"
read -r -a user_input;

if [[ $user_input = 0 ]]; then
    echo "Goodbye!"
    exit
fi
}

function convert_units() {
    echo "Type the line number to convert units or '0' to return"
    perl -ne 'print "$.. $_"' $file_name

    while true
    do

    read -r line_number
    
    if [[ $line_number = 0 ]]
    then
        break
    fi

    if ! [[ $line_number -gt 0 ]] && ! [[ $line_number -le $line_amount ]]; then
        while true
        do
        echo -e "Enter a valid line number!2"
        read -r line_number
        # return
        done
    fi

    line_amount="$(sed -n '$=' "$file_name")"
    line=$(sed "${line_number}!d" "$file_name")

    read -a text <<< "$line"
    
    if [[ $line_number -gt 0 ]] && [[ $line_number -le $line_amount ]]; then
        converteur

    else
        while true
        do
        echo -e "Enter a valid line number!"
        read -r line_number
        if [[ $line_number -gt 0 ]] && [[ $line_number -le $line_amount ]]; then
            converteur
            break
        fi 
        done
    fi
    done
}

function converteur {
    line=$(sed "${line_number}!d" "$file_name")
            
    read -a text <<< "$line"

    echo "Enter a value to convert:"
    read -a value_to_convert

    while [[ ! $value_to_convert =~ $check_float ]]
    do
    echo "Enter a float or integer value!"
    read -a value_to_convert
    done

    echo "Result: $(echo "scale=2; ${text[1]} * $value_to_convert" | bc -l)"  #multiplies by line number, needs to multiple by given input (int / float) now?
    menu
}

function remove_definition() {
    
    echo -e "Type the line number to delete or '0' to return"
    perl -ne 'print "$.. $_"' $file_name


    while true
    do

    read -r -a prompt_remove
    line_amount="$(sed -n '$=' "$file_name")"

    if [[ "$prompt_remove" = 0 ]];
    then
        line_amount="$(sed -n '$=' "$file_name")"
        return
    fi

    case ${prompt_remove} in
        $line_amount)
            if [[ "$prompt_remove" = 0 ]];
            then
                line_amount="$(sed -n '$=' "$file_name")"
                return
            fi
            line_amount="$(sed -n '$=' "$file_name")"
            sed -i "${prompt_remove}d" "$file_name"
            line_amount="$(sed -n '$=' "$file_name")"
            break
            ;;
        *)     
            echo -e "Enter a valid line number!"
            line_amount="$(sed -n '$=' "$file_name")"
            line_number=$prompt_remove
            line_amount="$(sed -n '$=' "$file_name")"
            ;;
    esac
    done
}

function add_definition() {
echo -e "Enter a definition:"
read -a user_input

arr_length="${#user_input[@]}"
definition="${user_input[0]}"
constant="${user_input[1]}"

rs='[a-z]+_to_[a-z]+'
check_float='^[-,0-9,.]+$'

if [[ ("$arr_length" = 2) && ($definition =~ $rs) && ($constant =~ $check_float) ]]; then
    line="${user_input[@]}"
    echo "$line" >> "$file_name"
else
    echo "The definition is incorrect!"
    add_definition
fi
}

while true
do
menu

case "${user_input}" in

    0 | 'quit')       
        echo -e "Goodbye!"
        break
        ;;
    1)
        if [ ! -s $file_name ]; then
            echo -e "Please add a definition first!"         
        else
            convert_units
        fi 
        ;;
    2)     
        add_definition 
        ;;
    3)     
        if [ ! -s $file_name ]; then
            echo -e "Please add a definition first!"
        else
            remove_definition
        fi
        ;;
    *)     
        echo -e "Invalid option!"
        ;;

esac
done