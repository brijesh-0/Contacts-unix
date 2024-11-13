#!/bin/bash

# Function to check if the username is provided
check_username() {
    if [ $# -eq 0 ]; then
        zenity --error --title="Error" --text="Username not provided."
        exit 1
    fi
}


username="$1"

user_database_folder="database/$username"
contact_file="$user_database_folder/contacts.csv"


# Function to handle editing contact using Zenity forms
edit_contact() {
    result=$(zenity --forms \
            --title="Edit Contact" \
            --text="Enter the details to edit the contact:" \
            --separator="," \
            --add-entry="Old Name: " \
            --add-entry="New Name: " \
            --add-entry="New Phone Number: " \
            --add-entry="New E-Mail: " \
            --add-calendar="Birthday: " \
            --add-entry="Favorite (yes/no): ")

    # Validate the result
    if [ -z "$result" ]; then
        zenity --error --title="Error" --text="No input provided. Please try again."
        return
    fi

    # Convert all input data to lowercase
    result=$(echo "$result" | tr '[:upper:]' '[:lower:]' | awk -F',' '{for(i=1;i<=NF;i++)if(!$i)$i="-"}{print}' OFS=',')

    IFS="," read -r old_name new_name new_phone new_email new_birthday is_favorite <<< "$result"

    # Check if the old name exists in the CSV file
    if grep -q "$old_name," "$contact_file"; then
        # Edit the contact in the CSV file
        sed -i "s|^$old_name,.*$|$new_name,$new_phone,$new_email,$new_birthday,$is_favorite|" "$contact_file"

        zenity --info --title="Edit Contact" --text="Contact edited successfully."
    else
        zenity --error --title="Edit Contact" --text="Contact not found. Please check the name and try again."
    fi
}

# Main program
check_username "$@"

if [ -e "$contact_file" ]; then
    edit_contact
else
    zenity --error --title="Edit Contact" --text="No contacts found. Please add contacts first."
fi

./scripts/utils/phone_directory_menu.sh "$username"