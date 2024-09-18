#!/bin/bash

download_urls() {
    # Check if the input file argument is provided
    if [ $# -eq 0 ]; then
        echo "Usage: download_urls <url_list_file>"
        return 1
    fi

    # Get the input file path
    url_list_file="$1"

    # Check if the file exists
    if [ ! -f "$url_list_file" ]; then
        echo "Error: The specified file does not exist."
        return 1
    fi

    # Create a folder to store downloaded files (optional)
    download_folder="downloaded_files"
    mkdir -p "$download_folder"

    # Specify the log file
    log_file="download_log.txt"

    # Clear existing log file or create a new one
    > "$log_file"

    # Download each URL in the file and log the results
    while IFS= read -r url; do
        wget "$url" -P "$download_folder" >> "$log_file" 2>&1
    done < "$url_list_file"

    echo "Download completed. Files saved in $download_folder. Log saved in $log_file"
}

# Example usage
# download_urls "url_list.txt"

