#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to get the current date and time
get_current_datetime() {
    date +"%Y-%m-%d %H:%M:%S"
}

# Function to check if a variable is empty
is_variable_empty() {
    [ -z "$1" ]
}

# Function to check if a string contains a substring
string_contains() {
    [ -z "${2##*$1*}" ]
}

# Function to check if a string starts with a specific substring
string_starts_with() {
    case $2 in
        $1*) true;;
        *) false;;
    esac
}

# Function to check if a string ends with a specific substring
string_ends_with() {
    case $2 in
        *$1) true;;
        *) false;;
    esac
}

# Function to convert a string to lowercase
string_to_lowercase() {
    echo "$1" | tr '[:upper:]' '[:lower:]'
}

# Function to convert a string to uppercase
string_to_uppercase() {
    echo "$1" | tr '[:lower:]' '[:upper:]'
}

# Function to generate a random alphanumeric string
generate_random_string() {
    cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w "$1" | head -n 1
}

# Function to generate a random numeric string
generate_random_numeric_string() {
    cat /dev/urandom | tr -dc '0-9' | fold -w "$1" | head -n 1
}