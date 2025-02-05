Kali Linux provides several tools for analyzing URLs for malicious content. Here are some tools and commands you can use to check URLs for potential threats:

### 1. **cURL**
   Use `curl` to inspect the HTTP headers and response body of a URL. This can help identify suspicious redirects, server information, and whether the site tries to load any malicious scripts.

   ```bash
   curl -I http://example.com
   curl -L http://example.com
   ```

   The `-I` option only fetches headers, while `-L` follows redirects to see where the URL leads.

### 2. **wget**
   `wget` is similar to `curl` but can download the entire content of a webpage. It can be helpful to check for any unexpected content or files.

   ```bash
   wget --spider http://example.com
   ```

   The `--spider` option checks if the URL is accessible without downloading the content.

### 3. **urlscan.io**
   `urlscan.io` is an online service for scanning URLs. You can use their API to check a URL and see detailed reports about its connections, resources, and potential malicious content. (Requires an API key from [urlscan.io](https://urlscan.io))

   ```bash
   curl -X POST "https://urlscan.io/api/v1/scan/" \
     -H "Content-Type: application/json" \
     -H "API-Key: YOUR_API_KEY" \
     -d '{"url": "http://example.com", "visibility": "public"}'
   ```

   Replace `YOUR_API_KEY` with your actual API key and `http://example.com` with the URL you want to check.

### 4. **Maltrail**
   Maltrail is a network traffic analyzer that monitors connections and alerts about potentially malicious domains. Start it and check for connections to suspicious URLs.

   ```bash
   sudo maltrail-sensor
   ```

   Run it alongside network traffic from your browser or other apps to see if any visited URL appears malicious.

### 5. **whois**
   `whois` provides domain registration information, which can help identify suspicious URLs by checking their creation dates, registrar, and owner information.

   ```bash
   whois example.com
   ```

   Look for recently created domains or those with limited information, which are often used for phishing and other malicious activities.

### 6. **Nslookup and Dig**
   These tools help inspect the DNS records of a URL, providing information on its IP addresses, CNAMEs, and associated domains. This can reveal connections to malicious IP addresses or unusual configurations.

   ```bash
   nslookup example.com
   dig example.com
   ```

### 7. **Check Google Safe Browsing API**
   Google Safe Browsing API can provide information about whether a URL is flagged as dangerous. You need to set up an API key through Google Cloud to use this.

   ```bash
   curl -X POST "https://safebrowsing.googleapis.com/v4/threatMatches:find?key=YOUR_API_KEY" \
     -H "Content-Type: application/json" \
     -d '{
       "client": {
         "clientId":      "yourcompanyname",
         "clientVersion": "1.5.2"
       },
       "threatInfo": {
         "threatTypes":      ["MALWARE", "SOCIAL_ENGINEERING"],
         "platformTypes":    ["ANY_PLATFORM"],
         "threatEntryTypes": ["URL"],
         "threatEntries": [
           {"url": "http://example.com"}
         ]
       }
     }'
   ```

   Replace `YOUR_API_KEY` with your actual Google API key. This will return any potential matches for malicious content on the URL.

### 8. **URL Reputation Check with VirusTotal**
   VirusTotal offers an online URL scanning service. You can use their API (with an API key from [VirusTotal](https://www.virustotal.com/)) to check for potential threats in URLs.

   ```bash
   curl -X POST "https://www.virustotal.com/vtapi/v2/url/report" \
     -d apikey=YOUR_API_KEY \
     -d resource="http://example.com"
   ```

   Replace `YOUR_API_KEY` with your VirusTotal API key and `http://example.com` with the URL to scan.

### 9. **Phishing and Malware Scanners**
   Tools like `phishcheck` or `phishtank` are specialized in identifying phishing websites. PhishTank provides a free API to check for phishing URLs.

   ```bash
   curl "https://checkurl.phishtank.com/checkurl/" \
     -d url="http://example.com" -d format=json -d app_key="YOUR_APP_KEY"
   ```

### Summary of Commands
1. Basic inspection with `curl` and `wget`.
2. URL analysis via `urlscan.io`, VirusTotal, or Google Safe Browsing.
3. DNS lookup with `whois`, `nslookup`, and `dig`.
4. Network monitoring with **Maltrail**.
5. Phishing checks with PhishTank or other tools.

---
Here are some examples of how to use `curl` and `wget` to analyze URLs and inspect their behavior or content.

### Using `curl`

#### 1. Fetch Only HTTP Headers
   The `-I` option tells `curl` to fetch only the headers, which can reveal information about the server, redirection policies, and security settings.

   ```bash
   curl -I http://example.com
   ```

   **Example Output:**
   ```
   HTTP/1.1 200 OK
   Date: Wed, 06 Nov 2024 10:00:00 GMT
   Server: Apache
   Content-Type: text/html; charset=UTF-8
   ```

#### 2. Follow Redirects
   Use `-L` to follow redirects, which can help you identify where a URL ultimately leads (useful for checking for phishing sites).

   ```bash
   curl -L http://example.com
   ```

   This will fetch the final destination URL content if there are multiple redirects.

#### 3. Save Content to a File
   The `-o` option saves the URL content to a file for further analysis.

   ```bash
   curl -o page_content.html http://example.com
   ```

#### 4. Display Full Response (Headers + Content)
   By default, `curl` displays both headers and content. This can help you inspect the full response from a server.

   ```bash
   curl http://example.com
   ```

#### 5. Customize User-Agent
   Some malicious sites respond differently to different User-Agents. You can set a custom User-Agent with the `-A` option.

   ```bash
   curl -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64)" http://example.com
   ```

#### 6. Show Only the IP Address of the URL
   Using `curl` with the `-s` (silent) and `--resolve` options allows you to see only the IP address.

   ```bash
   curl -s --resolve example.com:80:93.184.216.34 http://example.com
   ```

### Using `wget`

#### 1. Check if a URL is Accessible (Without Downloading Content)
   The `--spider` option lets you check the URL's status without downloading content. This is useful for determining if a page is online or offline.

   ```bash
   wget --spider http://example.com
   ```

   **Example Output:**
   ```
   HTTP request sent, awaiting response... 200 OK
   ```

#### 2. Download a Webpage Content
   Download the full content of a webpage using `wget`. This can be useful to inspect the HTML and resources of the page.

   ```bash
   wget http://example.com
   ```

   This command saves the content as a file named `index.html` in the current directory.

#### 3. Download with Recursive Depth (Useful for Analysis)
   Download the main page and all linked pages up to a specified depth with the `-r` option, which is useful to analyze the content of a site.

   ```bash
   wget -r -l 1 http://example.com
   ```

   The `-l 1` option specifies a depth of 1 (only the main page and directly linked pages).

#### 4. Customize User-Agent
   Similar to `curl`, you can set a custom User-Agent in `wget` with the `--user-agent` option.

   ```bash
   wget --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64)" http://example.com
   ```

#### 5. Download All Resources from a URL
   The `-p` option downloads all the necessary resources (images, CSS, JavaScript) to display the page as it would look in a browser.

   ```bash
   wget -p http://example.com
   ```

#### 6. Save Output to a Specific File
   Use the `-O` option to specify the filename for the downloaded content.

   ```bash
   wget -O my_output.html http://example.com
   ```

### Summary
- Use **`curl`** for quick inspections (headers, redirections, IP resolution) and single-page downloads.
- Use **`wget`** for deeper inspections (recursive downloads, resource fetching).

Shell script that takes a URL as an argument, uses `curl` and `wget` to analyze it, and saves all output to a text file.

```bash
#!/bin/bash

# Check if a URL is provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <URL>"
  exit 1
fi

# Define URL and output file
URL="$1"
OUTPUT_FILE="url_analysis_output.txt"

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
echo -e "\n=== Save Content to File (curl -o page_content.html) ===" | tee -a "$OUTPUT_FILE"
curl -o page_content.html "$URL" >> "$OUTPUT_FILE" 2>&1
echo "Content saved to page_content.html" | tee -a "$OUTPUT_FILE"

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
echo -e "\n=== Download Content (wget) ===" | tee -a "$OUTPUT_FILE"
wget "$URL" -O wget_page_content.html >> "$OUTPUT_FILE" 2>&1
echo "Content saved to wget_page_content.html" | tee -a "$OUTPUT_FILE"

# Download with recursive depth using wget
echo -e "\n=== Recursive Download (wget -r -l 1) ===" | tee -a "$OUTPUT_FILE"
wget -r -l 1 "$URL" -P wget_recursive_content >> "$OUTPUT_FILE" 2>&1
echo "Recursive content saved to wget_recursive_content directory" | tee -a "$OUTPUT_FILE"

# Set a custom User-Agent with wget
echo -e "\n=== Custom User-Agent (wget --user-agent) ===" | tee -a "$OUTPUT_FILE"
wget --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64)" "$URL" -O wget_user_agent_content.html >> "$OUTPUT_FILE" 2>&1
echo "Content saved to wget_user_agent_content.html" | tee -a "$OUTPUT_FILE"

# Download all resources from the URL with wget
echo -e "\n=== Download All Resources (wget -p) ===" | tee -a "$OUTPUT_FILE"
wget -p "$URL" -P wget_page_with_resources >> "$OUTPUT_FILE" 2>&1
echo "Page with resources saved to wget_page_with_resources directory" | tee -a "$OUTPUT_FILE"

# Finish
echo -e "\nAnalysis complete. Results saved to $OUTPUT_FILE."
```

### Instructions
1. Save this script to a file, e.g., `url_analysis.sh`.
2. Make it executable:
   ```bash
   chmod +x url_analysis.sh
   ```
3. Run it with a URL as an argument:
   ```bash
   ./url_analysis.sh http://example.com
   ```

### Explanation of Outputs
- **HTTP Headers**: Fetches headers with `curl`.
- **Follow Redirects**: Shows final content after redirects.
- **Save Content**: Saves the HTML content to `page_content.html`.
- **Full Response**: Fetches the full response, including body content.
- **Custom User-Agent**: Uses a custom User-Agent header.
- **Accessibility Check**: Checks if the URL is accessible using `wget`.
- **Download Content**: Saves content to `wget_page_content.html`.
- **Recursive Download**: Downloads linked pages up to one level.
- **Custom User-Agent with wget**