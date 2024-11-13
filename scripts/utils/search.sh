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

# Prompt the user to choose the search criteria
search_criteria=$(zenity --list --title="Search Contacts" --text="Choose search criteria:" \
                    --radiolist --column "Select" --column "Search Criteria" \
                    TRUE "Search by Name" FALSE "Search by Phone Number")

# Check if the CSV file exists
if [ -e "$contact_file" ]; then
    case "$search_criteria" in
        "Search by Name")
            search_term=$(zenity --entry --title="Search Contacts" --text="Enter the name:")
            search_result=$(awk -F',' -v search="$search_term" '$1 == search' "$contact_file")
            ;;
        "Search by Phone Number")
            search_term=$(zenity --entry --title="Search Contacts" --text="Enter the phone number:")
            search_result=$(awk -F',' -v search="$search_term" '$2 == search' "$contact_file")
            ;;
        *)
            zenity --error --title="Error" --text="Invalid selection."
            exit 1
            ;;
    esac

    if [ -z "$search_result" ]; then
        zenity --info --title="Search Result" --text="No matching contact found for \"$search_term\"."
    else
        zenity --list --title="Search Results" --width=600 --height=550 \
        --column="Name" --column="Phone Number" --column="Email" --column="Birthday" \
        --text="Contact List" \
        $(awk -F',' '{printf "%s %s %s %s ", $1, $2, $3, $4 }' <<< "$search_result") &&

        # Navigate back to the phone directory menu
        ./scripts/utils/phone_directory_menu.sh "$username"
    fi
else
    # Display an error message if no contacts are found
    zenity --error --title="Show All Contacts" --text="No contacts found. Please add contacts first."
fi
