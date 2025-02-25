#!/bin/bash

# Directory to monitor
WATCH_DIR="./uploads"

# Store the last checked state
LAST_CHECKED_STATE=""

# Function to check for new files
check_for_new_files() {
    # Get the current state of the directory
    CURRENT_STATE=$(ls "$WATCH_DIR")

    # Compare with the last checked state
    if [ "$CURRENT_STATE" != "$LAST_CHECKED_STATE" ]; then
        # Loop through new files
        for FILE in $CURRENT_STATE; do
            if [[ ! "$LAST_CHECKED_STATE" =~ "$FILE" ]]; then
                # If the file is new, run check.sh with the absolute path
                ABSOLUTE_PATH=$(realpath "$WATCH_DIR/$FILE")
                ../scripts/check.sh "$ABSOLUTE_PATH"
            fi
        done
    fi

    # Update the last checked state
    LAST_CHECKED_STATE="$CURRENT_STATE"
}

# Infinite loop to check for new files every 10 seconds
while true; do
    check_for_new_files
    sleep 10
done