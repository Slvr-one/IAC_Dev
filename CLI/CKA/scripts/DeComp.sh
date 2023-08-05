#!/bin/bash

# Function to check if a file is compressed
is_compressed() {
    local file=$1

    # Check if the file has a .zip extension
    if [[ "$file" == *.zip ]]; then
        return 0
    fi

    return 1
}

# Function to zip and remove the old file
zip_and_remove() {
    local file=$1
    local new_name

    # Zip the file with the new name
    new_name="zipped-$(basename "$file")"
    zip -q "$new_name" "$file"

    # Remove the old file
    rm "$file"

    echo "File '$file' has been zipped as '$new_name' and removed."
}

# Function to move and touch the compressed file
move_and_touch() {
    local file=$1
    local new_name

    # Move the file with the new name
    new_name="zipped-$(basename "$file")"
    mv "$file" "$new_name"

    # Touch the file to update its modification time
    touch "$new_name"

    echo "File '$file' has been moved as '$new_name' and touched."
}

# Function to remove old zipped files
remove_old_zipped_files() {
    local folder=$1

    # Find and remove zipped files older than 48 hours
    find "$folder" -name "zipped-*" -type f -mtime +2 -exec rm {} \;

    echo "Old zipped files in '$folder' have been removed."
}

# Function to process files in a folder
process_folder() {
    local folder=$1
    local recursive=$2

    # Iterate through files in the folder
    for file in "$folder"/*; do
        if [ -f "$file" ]; then
            if is_compressed "$file"; then
                move_and_touch "$file"
            else
                zip_and_remove "$file"
            fi
        elif [ -d "$file" ] && [ "$recursive" == "true" ]; then
            process_folder "$file" "$recursive"
        fi
    done
}

# Main script

# Check the number of arguments
if [ $# -lt 1 ]; then
    echo "Usage: $0 [-r] folder"
    exit 1
fi

recursive=false
folder=""

# Parse command-line arguments
while getopts "r" opt; do
    case $opt in
        r)
            recursive=true
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

shift $((OPTIND-1))

# Check if the folder is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 [-r] folder"
    exit 1
fi

folder=$1

# Process files in the folder
process_folder "$folder" "$recursive"

# Remove old zipped files
remove_old_zipped_files "$folder"