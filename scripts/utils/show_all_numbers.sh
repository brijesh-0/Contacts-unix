#!/bin/bash

# Ensure that the username is provided as an argument
if [ $# -eq 0 ]; then
    zenity --error --title="Error" --text="Username not provided."
    exit 1
fi

# Extract the username from the argument
username="$1"

# Define the user's database folder and the CSV file path
user_database_folder="database/$username"
contact_file="$user_database_folder/contacts.csv"

# Check if the CSV file exists
if [ -e "$contact_file" ]; then
    sorted_file=$(sort -t',' -k1,1 "$contact_file")

    # Use zenity --list to display the formatted content
    zenity --list --title="All Contacts" --width=600 --height=650 \
    --column="Name" --column="Phone Number" --column="Email" --column="Birthday" \
    --text="Contact List" \
    $(awk -F',' '{printf "%s %s %s %s ", $1, $2, $3, $4 }' <<< "$sorted_file") &&

    # Navigate back to the phone directory menu
    ./scripts/utils/phone_directory_menu.sh "$username"
else
    # Display an error message if no contacts are found
    zenity --error --title="Show All Contacts" --text="No contacts found. Please add contacts first."
fi
