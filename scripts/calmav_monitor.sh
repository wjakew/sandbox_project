#!/bin/bash

# Define variables
WATCH_DIR="/home/vpn/dropin"   # Directory to monitor
REPORT_DIR="/home/vpn/takeit"  # Directory to save scan reports

# Ensure ClamAV is installed
if ! command -v clamscan &> /dev/null; then
    echo "Error: ClamAV (clamscan) is not installed. Please install it first."
    exit 1
fi

# Ensure inotifywait is installed
if ! command -v inotifywait &> /dev/null; then
    echo "Error: inotifywait is not installed. Please install inotify-tools."
    exit 1
fi

# Check if directories exist, create if necessary
if [ ! -d "$WATCH_DIR" ]; then
    echo "Error: Directory '$WATCH_DIR' does not exist."
    exit 1
fi

if [ ! -d "$REPORT_DIR" ]; then
    mkdir -p "$REPORT_DIR"
    echo "Created report directory: $REPORT_DIR"
fi

# Ensure ClamAV database is up-to-date
echo "Updating ClamAV database..."
if ! freshclam; then
    echo "Warning: freshclam failed. Ensure the ClamAV database is updated."
fi

echo "Monitoring directory: $WATCH_DIR"
echo "Scan reports will be saved in: $REPORT_DIR"

# Monitor directory for new files
inotifywait -m -e create --format '%w%f' "$WATCH_DIR" | while read NEW_FILE
do
    if [ -f "$NEW_FILE" ]; then
        # Get current timestamp for report name
        TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
        REPORT_FILE="$REPORT_DIR/virus_scan_report_$TIMESTAMP.txt"

        echo "New file detected: $NEW_FILE"

        # Write initial scan details to the report
        {
            echo "====== Virus Scan Report ======"
            echo "Scan Start Time: $(date)"
            echo "Scanned File: $NEW_FILE"
            echo "================================"
        } > "$REPORT_FILE"

        # Scan the file with ClamAV and append results to report
        clamscan "$NEW_FILE" >> "$REPORT_FILE"

        echo "Scan completed. Report saved to: $REPORT_FILE"
    fi
done