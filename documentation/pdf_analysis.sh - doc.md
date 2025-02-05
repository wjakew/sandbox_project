Skrypt instalujący
```bash
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

```

Skrypt docelowy

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

---

## Opis Skryptu

Skrypt służy do analizy plików PDF pod kątem bezpieczeństwa i metadanych. Przeprowadza różne testy przy użyciu narzędzi takich jak PDFid, pdf-parser, Peepdf, ExifTool, Yara, oraz ClamAV. Wyniki analizy są zapisywane do pliku tekstowego o nazwie `pdf_analysis_output.txt`.

### Struktura Skryptu

1. **Sprawdzenie argumentów wejściowych**: Skrypt sprawdza, czy podano ścieżkę do pliku PDF jako argument.
2. **Sprawdzenie dostępności narzędzi**: Skrypt sprawdza, czy wszystkie wymagane narzędzia są zainstalowane.
3. **Analiza pliku PDF**: Wykonywana jest analiza pliku PDF za pomocą każdego narzędzia, a wyniki są zapisywane w pliku wyjściowym.
4. **Podsumowanie wyników**: Po zakończeniu analizy skrypt wyświetla komunikat informujący o zakończeniu analizy.

---

## Opis Narzędzi

### 1. PDFid
- **Opis**: Narzędzie służy do podstawowej analizy plików PDF, pokazując potencjalnie złośliwe elementy, takie jak skrypty JavaScript, akcje, czy obiekty typu `/OpenAction`.
- **Link**: [PDFid](https://blog.didierstevens.com/programs/pdf-tools/)

### 2. pdf-parser
- **Opis**: Umożliwia bardziej zaawansowaną analizę struktury plików PDF, w tym analizę obiektów i ich właściwości, co pozwala zidentyfikować ukryte zagrożenia.
- **Link**: [pdf-parser](https://blog.didierstevens.com/programs/pdf-tools/)

### 3. Peepdf
- **Opis**: Peepdf pozwala na szczegółowe przeglądanie plików PDF, w tym analizę zawartości i wykrywanie zagrożeń. Umożliwia również przeprowadzanie działań interaktywnych na plikach.
- **Link**: [Peepdf](https://github.com/jesparza/peepdf)

### 4. ExifTool
- **Opis**: Narzędzie do wyodrębniania metadanych z plików, w tym plików PDF, które mogą zawierać informacje o autorze, dacie utworzenia, itp.
- **Link**: [ExifTool](https://exiftool.org/)

### 5. Yara
- **Opis**: Yara to narzędzie do identyfikacji i klasyfikacji złośliwego oprogramowania na podstawie reguł. Można go używać do wykrywania charakterystycznych wzorców w plikach PDF.
- **Link**: [Yara](https://virustotal.github.io/yara/)

### 6. ClamAV
- **Opis**: Antywirusowe narzędzie typu open-source służące do skanowania plików pod kątem obecności złośliwego oprogramowania, w tym wirusów i innych zagrożeń.
- **Link**: [ClamAV](https://www.clamav.net/)

---

## Instrukcje Uruchomienia na Kali Linux

1. **Instalacja narzędzi**:
   Na początek zainstaluj wymagane narzędzia. Możesz to zrobić za pomocą następujących komend:
   ```bash
   sudo apt update
   sudo apt install python3-pdfid pdf-parser peepdf exiftool yara clamav
   ```

2. **Pobierz skrypt**:
   Zapisz skrypt do pliku, na przykład `pdf_analysis.sh`.

3. **Nadaj uprawnienia do wykonania**:
   Aby skrypt był możliwy do uruchomienia, nadaj mu odpowiednie uprawnienia:
   ```bash
   chmod +x pdf_analysis.sh
   ```

4. **Uruchomienie skryptu**:
   Aby uruchomić skrypt, wykonaj poniższą komendę, podając ścieżkę do pliku PDF, który chcesz przeanalizować:
   ```bash
   ./pdf_analysis.sh /ścieżka/do/twojego/pliku.pdf
   ```

5. **Przegląd wyników**:
   Po zakończeniu analizy, wyniki będą zapisane w pliku `pdf_analysis_output.txt`, który możesz przejrzeć za pomocą dowolnego edytora tekstu lub polecenia `cat`:
   ```bash
   cat pdf_analysis_output.txt
   ```

--- 

## Dodatkowe Uwagi

- Jeśli nie masz pliku reguł Yara, upewnij się, że zaktualizujesz ścieżkę do pliku reguł (`YARA_RULES="/path/to/your/yara-rules.yar"`).
- Kali Linux zazwyczaj ma preinstalowane wiele z tych narzędzi, ale upewnij się, że są one aktualne i skonfigurowane poprawnie.