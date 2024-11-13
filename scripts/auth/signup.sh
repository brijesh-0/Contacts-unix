#!/bin/bash

# Function to convert name to lowercase
to_lowercase() {
    echo "$1" | tr '[:upper:]' '[:lower:]'
}

# Function to check if user already exists
user_exists() {
    local username="$1"
    local csv_file="users.csv"

    # Check if the user already exists (case-insensitive)
    if grep -qi "^$(to_lowercase "$username"):" "$csv_file"; then
        return 0  # User exists
    else
        return 1  # User does not exist
    fi
}

# Function to sign up a new user
sign_up() {
    local result=$(zenity --forms \
                    --title="Sign Up" \
                    --text="Enter your details:" \
                    --separator="," \
                    --add-entry="Name:" \
                    --add-password="Password:")

    # Check if the user clicked Cancel or closed the form
    if [ -z "$result" ]; then
        zenity --error \
               --title="Sign Up" \
               --text="Sign up canceled."
        return
    fi

    IFS="," read -r username password <<< "$result"

    # Check if the user already exists
    if user_exists "$username"; then
        zenity --error \
               --title="Sign Up" \
               --text="User already exists. Please choose a different name."
    else
        # Save user details to a CSV file
        echo "$(to_lowercase "$username"),$password" >> users.csv
        zenity --info \
               --title="Sign Up" \
               --text="Sign up successful! You can now login."
    fi
}

# Main function
sign_up

