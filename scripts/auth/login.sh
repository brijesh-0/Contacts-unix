#!/bin/bash

# Function to convert name to lowercase
to_lowercase() {
    echo "$1" | tr '[:upper:]' '[:lower:]'
}

# Function to check if user exists
user_exists() {
    local username="$1"
    local password="$2"
    local csv_file="users.csv"

    # Check if the user exists (case-insensitive)
    if grep -qi "^$(to_lowercase "$username"),$password" "$csv_file"; then
        return 0  # User exists
    else
        return 1  # User does not exist
    fi
}

# Function to log in
login() {
    local result=$(zenity --forms \
                    --title="Login" \
                    --text="Enter your credentials:" \
                    --add-entry="Username:" \
                    --add-password="Password:" \
                    --separator=",")

    local username=$(echo "$result" | cut -d',' -f1)
    local password=$(echo "$result" | cut -d',' -f2)

    # Check if user exists
    if user_exists "$username" "$password"; then
        # If user exists, pass username to phone directory script
        ./scripts/utils/phone_directory_menu.sh "$username"
    else
        zenity --error \
               --title="Login" \
               --text="Invalid credentials. Please try again."
    fi
}

# Main function
login
