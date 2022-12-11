#!/bin/bash

echo "Welcome to the Simple converter!"
touch definitions.txt
file_name="definitions.txt"
line_amount="$(sed -n '$=' "$file_name")"

function menu() {
printf '%s\n' \
"Select an option" \
"0. Type '0' or 'quit' to end program" \
"1. Convert units" \
"2. Add a definition" \
"3. Delete a definition"
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
            #continue
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
    # echo "${user_input[@]}" >> definitions.txt

    
    line="${user_input[@]}"
    echo "$line" >> "$file_name"

    # echo "Enter a value to convert:"
    # read -a second_user_input

    # while [[ ! $second_user_input =~ $check_float ]];
    # do
    #     echo "Enter a float or integer value!"
    #     read -a second_user_input 
    # done
    
    # echo "Result: $(echo "scale=2; $constant * $second_user_input" | bc -l)"
else
    echo "The definition is incorrect!"
    add_definition
line_amount="$(sed -n '$=' "$file_name")"
fi
}

while true
do
menu
read -r -a user_input;

case "${user_input}" in

    0 | 'quit')       
        echo -e "Goodbye!"
        break
        ;;
    1)     
        echo -e "Not implemented!" 
        ;;
    2)     
        add_definition 
        ;;
    3)     
        if [ ! -s $file_name ]; then
            echo -e "Please add a definition first!"
            # break
        else
            remove_definition
        fi
        ;;
    *)     
        echo -e "Invalid option!"
        ;;

esac
done