Kali Linux has a few tools to help analyze PDF files for potential malicious content. Here’s a list of commonly used tools and their commands to inspect PDFs:

### 1. **PDFid**
   PDFid is a tool that identifies possible malicious elements in a PDF file. It checks for suspicious keywords like `/JavaScript`, `/OpenAction`, and other potentially dangerous components.

   ```bash
   pdfid.py /path/to/your/file.pdf
   ```

   Look for keywords like `/JavaScript`, `/OpenAction`, or `/Launch` that indicate possible malicious actions.

### 2. **pdf-parser**
   pdf-parser is useful for analyzing the structure of the PDF in more detail. It can search for objects containing specific keywords and extract them for further inspection.

   ```bash
   pdf-parser.py -o 1 /path/to/your/file.pdf
   ```

   Common options include:
   - `-a` to show stats about object types
   - `-s "JavaScript"` to search for JavaScript specifically
   - `-o <object number>` to extract a particular object for inspection

### 3. **Peepdf**
   Peepdf is an advanced tool for analyzing and exploring PDF files. It provides a comprehensive analysis of the file's structure and any embedded scripts.

   ```bash
   peepdf /path/to/your/file.pdf
   ```

   This opens an interactive shell where you can investigate objects, streams, and other file parts. You can use `info` to get a summary of the file’s structure or `object <object number>` to investigate individual components.

### 4. **ExifTool**
   ExifTool can extract metadata from the PDF file, which can sometimes contain clues about potential tampering.

   ```bash
   exiftool /path/to/your/file.pdf
   ```

   This will show metadata, author information, creation dates, and more, which can help spot anything unusual.

### 5. **Yara**
   Yara is used for pattern matching and can detect known malicious signatures. You need to have some Yara rules prepared for detecting malicious PDFs.

   ```bash
   yara -r /path/to/yara-rules.yar /path/to/your/file.pdf
   ```

   Replace `/path/to/yara-rules.yar` with the Yara rules file you are using to scan for malware patterns in PDF files.

### 6. **ClamAV**
   ClamAV is an open-source antivirus that can scan files for known malware.

   ```bash
   clamscan /path/to/your/file.pdf
   ```

   ClamAV may not detect all PDF-based exploits, but it’s useful for spotting known threats.

### Quick Workflow Summary
1. **Start with PDFid** to look for high-level indicators.
2. **Use pdf-parser** or **Peepdf** for deeper structural analysis.
3. Check metadata with **ExifTool**.
4. Use **Yara** if you have access to PDF-specific rules.
5. Run **ClamAV** for antivirus scanning if you suspect known malware.
---
Shell script that takes the path to a PDF file as an argument, runs the listed tools, and saves the output to a text file:

```bash
#!/bin/bash

# Check if the file path is provided
if [ -z "$1" ]; then
  echo "Usage: $0 /path/to/your/file.pdf"
  exit 1
fi

# Define the PDF file path and output file
PDF_FILE="$1"
OUTPUT_FILE="pdf_analysis_output.txt"

# Clear the output file if it exists
> "$OUTPUT_FILE"

# Check if the tools are available
for tool in pdfid.py pdf-parser.py peepdf exiftool yara clamscan; do
  if ! command -v $tool &> /dev/null; then
    echo "$tool is not installed. Please install it and try again." >> "$OUTPUT_FILE"
    exit 1
  fi
done

# Run PDFid
echo "=== PDFid Analysis ===" >> "$OUTPUT_FILE"
pdfid.py "$PDF_FILE" >> "$OUTPUT_FILE" 2>&1
echo -e "\n" >> "$OUTPUT_FILE"

# Run pdf-parser
echo "=== pdf-parser Analysis ===" >> "$OUTPUT_FILE"
pdf-parser.py -a "$PDF_FILE" >> "$OUTPUT_FILE" 2>&1
echo -e "\n" >> "$OUTPUT_FILE"

# Run Peepdf
echo "=== Peepdf Analysis ===" >> "$OUTPUT_FILE"
peepdf "$PDF_FILE" -c "info" >> "$OUTPUT_FILE" 2>&1
echo -e "\n" >> "$OUTPUT_FILE"

# Run ExifTool
echo "=== ExifTool Metadata ===" >> "$OUTPUT_FILE"
exiftool "$PDF_FILE" >> "$OUTPUT_FILE" 2>&1
echo -e "\n" >> "$OUTPUT_FILE"

# Run Yara if rules file is specified
YARA_RULES="/path/to/your/yara-rules.yar" # Replace with the path to your Yara rules file
if [ -f "$YARA_RULES" ]; then
  echo "=== Yara Analysis ===" >> "$OUTPUT_FILE"
  yara -r "$YARA_RULES" "$PDF_FILE" >> "$OUTPUT_FILE" 2>&1
  echo -e "\n" >> "$OUTPUT_FILE"
else
  echo "Yara rules file not found at $YARA_RULES. Skipping Yara analysis." >> "$OUTPUT_FILE"
fi

# Run ClamAV
echo "=== ClamAV Antivirus Scan ===" >> "$OUTPUT_FILE"
clamscan "$PDF_FILE" >> "$OUTPUT_FILE" 2>&1
echo -e "\n" >> "$OUTPUT_FILE"

# Finish
echo "Analysis complete. Results saved to $OUTPUT_FILE."
```

### Instructions
1. Save this script to a file, e.g., `pdf_analysis.sh`.
2. Make it executable with:
   ```bash
   chmod +x pdf_analysis.sh
   ```
3. Run it with the path to the PDF file as an argument:
   ```bash
   ./pdf_analysis.sh /path/to/your/file.pdf
   ```

### Notes
- Replace `/path/to/your/yara-rules.yar` with the actual path to your Yara rules file.
- This script checks if each tool is installed and skips the Yara analysis if no rules file is found.
- The output of each tool is appended to `pdf_analysis_output.txt` in the same directory as the script. 