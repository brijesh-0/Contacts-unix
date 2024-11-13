#!/bin/bash

# Usage: ./view_profile.sh "contact_name:contact_number"
contact_info="$1"

# Extract name and number from the input
name=$(echo "$contact_info" | cut -d":" -f1)
number=$(echo "$contact_info" | cut -d":" -f2)

# Fetch additional details from users.txt or set default values
user_details=$(grep "^$name:" users.txt | cut -d":" -f2)
IFS=':' read -r address company birthday <<< "$user_details"
address=${address:-"N/A"}
company=${company:-"N/A"}
birthday=${birthday:-"N/A"}

# Display the contact profile using zenity
zenity --info \
       --title="Contact Profile - $name" \
       --text="Name: $name\nPhone No: $number\nAddress: $address\nCompany: $company\nBirthday: $birthday" \
       --width=300 --height=200

