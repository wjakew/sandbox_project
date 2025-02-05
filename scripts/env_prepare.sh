#!/bin/bash

# Update package lists
sudo apt update

# Install Python if it's not already installed
if ! command -v python3 &> /dev/null; then
  echo "Installing Python3..."
  sudo apt install -y python3 python3-pip
fi

# Install pdfid.py and pdf-parser.py from Didier Stevens' tools
if ! command -v pdfid.py &> /dev/null; then
  echo "Installing pdfid.py..."
  sudo pip3 install pdfid
fi

if ! command -v pdf-parser.py &> /dev/null; then
  echo "Installing pdf-parser.py..."
  sudo pip3 install pdf-parser
fi

# Install peepdf
if ! command -v peepdf &> /dev/null; then
  echo "Installing peepdf..."
  sudo apt install -y peepdf
fi

# Install ExifTool
if ! command -v exiftool &> /dev/null; then
  echo "Installing ExifTool..."
  sudo apt install -y exiftool
fi

# Install Yara
if ! command -v yara &> /dev/null; then
  echo "Installing Yara..."
  sudo apt install -y yara
fi

# Install ClamAV
if ! command -v clamscan &> /dev/null; then
  echo "Installing ClamAV..."
  sudo apt install -y clamav
fi

echo "All tools installed successfully."
