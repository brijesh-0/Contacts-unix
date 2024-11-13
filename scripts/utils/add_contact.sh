#!/bin/bash

# Ensure that the username is provided as an argument
if [ $# -eq 0 ]; then
    zenity --error --title="Error" --text="Username not provided."
    exit 1
fi

# Extract the username from the argument
username="$1"

# Function to create or update user database folder
create_or_update_user_database_folder() {
    user_database_folder="database/$username"
    mkdir -p "$user_database_folder"
}

# Function to add a contact
add_contact() {
    result=$(zenity --forms \
            --title="Add Contact" \
            --text="Enter contact details:" \
            --separator="," \
            --add-entry="Name: " \
            --add-entry="Phone Number: " \
            --add-entry="Email:  " \
            --add-calendar="Birthday: " \
            --add-entry="Favorite (yes/no): ")

    # Validate the result
    if [ -z "$result" ]; then
        zenity --error --title="Error" --text="No input provided. Please try again."
        return
    fi

    # Convert all input data to lowercase and handle empty inputs
    result=$(echo "$result" | tr '[:upper:]' '[:lower:]' | awk -F',' '{for(i=1;i<=NF;i++)if(!$i)$i="-"}{print}' OFS=',')


    IFS="," read -r contact_name contact_phone contact_email contact_birthday <<< "$result"

    # Validate individual fields
    if [ -z "$contact_name" ] || [ -z "$contact_phone" ]; then
        zenity --error --title="Error" --text="Name and Phone Number are required fields. Please fill them in."
        return
    fi

    # CSV file path
    csv_file="$user_database_folder/contacts.csv"

    # Check if the CSV file is empty
    # if [ ! -s "$csv_file" ]; then
    #     # Add header line to the CSV file
    #     echo "Name,Phone Number,E-Mail,Birthday" > "$csv_file"
    # fi

    # Check if the phone number already exists
    if grep -q "^$contact_name,$contact_phone," "$csv_file"; then
        # Modify the CSV file
            zenity --info --title="Error!" --text="Contact already exists\nPlease try again."
    else
        # Add contact to the CSV file
        echo "$contact_name,$contact_phone,$contact_email,$contact_birthday" >> "$csv_file"
        zenity --info --title="Add Contact" --text="Contact added successfully."
    fi
}

# Main function
create_or_update_user_database_folder
add_contact
./scripts/utils/phone_directory_menu.sh "$username"
