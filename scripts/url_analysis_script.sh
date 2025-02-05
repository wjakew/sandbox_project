#!/bin/bash

# Check if a URL is provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <URL>"
  exit 1
fi

# Define URL and extract domain name
URL="$1"
DOMAIN=$(echo "$URL" | awk -F/ '{print $3}')

# Create a directory with the domain name
OUTPUT_DIR="$DOMAIN"
mkdir -p "$OUTPUT_DIR"

# Define the main output file path
OUTPUT_FILE="$OUTPUT_DIR/url_analysis_output.txt"

# Clear the output file if it exists
> "$OUTPUT_FILE"

echo "Analyzing URL: $URL" | tee -a "$OUTPUT_FILE"

# Fetch only HTTP headers with curl
echo -e "\n=== HTTP Headers (curl -I) ===" | tee -a "$OUTPUT_FILE"
curl -I "$URL" >> "$OUTPUT_FILE" 2>&1

# Follow redirects and get the final content with curl
echo -e "\n=== Follow Redirects and Fetch Content (curl -L) ===" | tee -a "$OUTPUT_FILE"
curl -L "$URL" >> "$OUTPUT_FILE" 2>&1

# Save the content of the page to a file with curl
PAGE_CONTENT_FILE="$OUTPUT_DIR/page_content.html"
echo -e "\n=== Save Content to File (curl -o page_content.html) ===" | tee -a "$OUTPUT_FILE"
curl -o "$PAGE_CONTENT_FILE" "$URL" >> "$OUTPUT_FILE" 2>&1
echo "Content saved to $PAGE_CONTENT_FILE" | tee -a "$OUTPUT_FILE"

# Display full response (headers + content) with curl
echo -e "\n=== Full Response (curl) ===" | tee -a "$OUTPUT_FILE"
curl "$URL" >> "$OUTPUT_FILE" 2>&1

# Customize User-Agent with curl
echo -e "\n=== Custom User-Agent (curl -A) ===" | tee -a "$OUTPUT_FILE"
curl -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64)" "$URL" >> "$OUTPUT_FILE" 2>&1

# Check if URL is accessible with wget
echo -e "\n=== URL Accessibility Check (wget --spider) ===" | tee -a "$OUTPUT_FILE"
wget --spider "$URL" >> "$OUTPUT_FILE" 2>&1

# Download content of the URL with wget
WGET_CONTENT_FILE="$OUTPUT_DIR/wget_page_content.html"
echo -e "\n=== Download Content (wget) ===" | tee -a "$OUTPUT_FILE"
wget "$URL" -O "$WGET_CONTENT_FILE" >> "$OUTPUT_FILE" 2>&1
echo "Content saved to $WGET_CONTENT_FILE" | tee -a "$OUTPUT_FILE"

# Download with recursive depth using wget
WGET_RECURSIVE_DIR="$OUTPUT_DIR/wget_recursive_content"
echo -e "\n=== Recursive Download (wget -r -l 1) ===" | tee -a "$OUTPUT_FILE"
wget -r -l 1 "$URL" -P "$WGET_RECURSIVE_DIR" >> "$OUTPUT_FILE" 2>&1
echo "Recursive content saved to $WGET_RECURSIVE_DIR directory" | tee -a "$OUTPUT_FILE"

# Set a custom User-Agent with wget
WGET_USER_AGENT_FILE="$OUTPUT_DIR/wget_user_agent_content.html"
echo -e "\n=== Custom User-Agent (wget --user-agent) ===" | tee -a "$OUTPUT_FILE"
wget --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64)" "$URL" -O "$WGET_USER_AGENT_FILE" >> "$OUTPUT_FILE" 2>&1
echo "Content saved to $WGET_USER_AGENT_FILE" | tee -a "$OUTPUT_FILE"

# Download all resources from the URL with wget
WGET_RESOURCES_DIR="$OUTPUT_DIR/wget_page_with_resources"
echo -e "\n=== Download All Resources (wget -p) ===" | tee -a "$OUTPUT_FILE"
wget -p "$URL" -P "$WGET_RESOURCES_DIR" >> "$OUTPUT_FILE" 2>&1
echo "Page with resources saved to $WGET_RESOURCES_DIR directory" | tee -a "$OUTPUT_FILE"

# Perform traceroute to the URL's domain
echo -e "\n=== Traceroute to $DOMAIN ===" | tee -a "$OUTPUT_FILE"
traceroute "$DOMAIN" >> "$OUTPUT_FILE" 2>&1

# Ping the URL's domain
echo -e "\n=== Ping $DOMAIN ===" | tee -a "$OUTPUT_FILE"
ping -c 4 "$DOMAIN" >> "$OUTPUT_FILE" 2>&1

# WHOIS lookup for the domain
echo -e "\n=== WHOIS Lookup for $DOMAIN ===" | tee -a "$OUTPUT_FILE"
whois "$DOMAIN" >> "$OUTPUT_FILE" 2>&1

# Finish
echo -e "\nAnalysis complete. Results saved to $OUTPUT_FILE."

```
