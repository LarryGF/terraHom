#!/bin/bash

# Prompt for username, email, and password
read -p "Enter username: " username
read -p "Enter email: " email
read -s -p "Enter password: " password
echo

# Hash the password using Argon2
hashed_password=$(echo -n "$password" | argon2 eUhVT1dQa082YVk2VUhDMQ -id -t 1 -m 15 -p 8 -l 32 | grep 'Encoded:' | awk '{print $2}')

echo $hashed_password
# Generate the required YAML format and append to users.config
cat <<EOL >> ./users.config
${username}:
  disabled: false
  displayname: "${username}"
  password: "${hashed_password}"
  email: ${email}
  groups:
    - admins
    - dev

EOL

echo "User details appended to users.config"
