#!/bin/bash

# Function for phone directory options
phone_directory_menu() {
    local username=$1

    choice=$(zenity --list \
                    --title="Phone Directory" \
                    --column="Option" "Add Contact" "Show All Contacts" "Edit Contact" "Delete Contact" "Favorite Contacts" "Search" "Logout" \
                    --width=400 --height=650)

    case $choice in
        "Add Contact")
            ./scripts/utils/add_contact.sh "$username";;
        "Show All Contacts")
            ./scripts/utils/show_all_numbers.sh "$username";;
        "Edit Contact")
            ./scripts/utils/edit_contact.sh "$username";;
        "Delete Contact")
            ./scripts/utils/delete_contact.sh "$username";;
        "Favorite Contacts")
            ./scripts/utils/favorite_contacts.sh "$username";;
        "Search")
            ./scripts/utils/search.sh "$username";;
        "Logout")
            return 1;;
    esac
}

# Invoke phone_directory_menu function with the received username
phone_directory_menu "$1"
