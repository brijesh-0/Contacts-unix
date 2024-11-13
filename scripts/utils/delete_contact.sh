#!/bin/bash

if [ $# -eq 0 ]; then
    zenity --error --title="Error" --text="Username not provided."
    exit 1
fi

# Extract the username from the argument
username="$1"

# Define user-specific paths
user_database_folder="database/$username"
contact_file="$user_database_folder/contacts.csv"

delete_contact() {
    # Check if the CSV file exists
    if [ -e "$contact_file" ]; then
        # Use Zenity forms to get name and phone number
        result=$(zenity --forms \
            --title="Delete Contact" \
            --text="Enter contact details:" \
            --separator="," \
            --add-entry="Name: " \
            --add-entry="Phone Number: ")
            

        # Validate the result
        if [ -z "$result" ]; then
            zenity --error --title="Error" --text="No input provided. Please try again."
            return
        fi

        # Convert all input data to lowercase
        result=$(echo "$result" | tr '[:upper:]' '[:lower:]')

        # Extract name and phone number from the result
        IFS="," read -r contact_name contact_phone <<< "$result"

        # Delete the line in the CSV file based on name and phone number
        sed -i "/^$contact_name,$contact_phone,/d" "$contact_file"

        zenity --info --title="Delete Contact" --text="Contact deleted successfully."
    else
        zenity --error --title="Delete Contact" --text="No contacts found. Please add contacts first."
    fi
}

delete_contact
./scripts/utils/phone_directory_menu.sh "$username"
