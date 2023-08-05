#!/bin/bash

# Default values
count=-1
timeout=1
user=""

# Function to count live processes for a user
count_live_processes() {
    local exe_name=$1
    local user_name=$2
    local process_count

    # Count the number of live processes for the given user and executable name
    # process_count=$(ps -u "$user_name" -o cmd | grep "$exe_name" | grep -v grep | wc -l)
    process_count=$(psgrep "$exe_name" -u "$user_name" | wc -l)

    echo "Number of live processes for user '$user_name' and executable '$exe_name': $process_count"
}

# Parse command-line arguments
while getopts "c:t:u:" opt; do
    case $opt in
        c)
            count=$OPTARG
            ;;
        t)
            timeout=$OPTARG
            ;;
        u)
            user=$OPTARG
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

shift $((OPTIND-1))

# Check if the executable name is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 [-c count] [-t timeout] [-u user] exe-name"
    exit 1
fi

exe_name=$1

# Main loop
if [ "$count" -eq -1 ]; then
    while true; do
        count_live_processes "$exe_name" "$user"
        sleep "$timeout"
    done
else
    for ((i=0; i<count; i++)); do
        count_live_processes "$exe_name" "$user"
        sleep "$timeout"
    done
fi