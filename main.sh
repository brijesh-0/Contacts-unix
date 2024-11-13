#!/bin/bash

# Function to display the main menu
show_menu() {
    choice=$(zenity --list \
                    --title="Phone Directory" \
                    --column="Option" "Sign Up" "Login" "Exit" \
                    --width=500 --height=350)
}

# Function for user sign up
sign_up() {
    ./scripts/auth/signup.sh
}

# Function for user login
login() {
    ./scripts/auth/login.sh
}

# Function for phone directory options
phone_directory_menu() {
    ./scripts/utils/phone_directory_menu.sh
}

# Main loop
while true; do
    show_menu
    case $choice in
        "Sign Up")
            sign_up;;
        "Login")
            login;;
        "Exit")
            exit;;
    esac
done

