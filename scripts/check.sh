#!/bin/bash

FILE_PATH="$1"

# Check if the file exists
if [ ! -f "$FILE_PATH" ]; then
    echo "Error: The provided path is not a file."
    exit 1
fi
