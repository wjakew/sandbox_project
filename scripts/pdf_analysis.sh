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
