*Kod do analizy podejrzanego URLa*
*by Jakub Wawak*
## Kod skryptu:

```bash
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

## Zastosowanie

Ten skrypt jest narzędziem do analizy strony internetowej za pomocą poleceń `curl` i `wget`. Sprawdza dostępność URL-a, pobiera nagłówki HTTP, podąża za przekierowaniami, zapisuje zawartość strony oraz ściąga wszystkie zasoby powiązane z daną stroną. Dodatkowo pozwala na ustawienie niestandardowego nagłówka User-Agent, symulując przeglądarkę internetową.

Skrypt ten przygotowuje dane dotyczące danej strony do dalszej weryfikacji po stronie administratora bezpieczeństwa - umożliwia kompleksową weryfikacje tego co strona wyświetla, jakie skrypty są uruchamiane na stronie.

## Opis kodu

```bash
#!/bin/bash
```
Ta linia definiuje interpreter, który ma zostać użyty do uruchomienia skryptu, w tym przypadku `/bin/bash`.

```bash
# Check if a URL is provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <URL>"
  exit 1
fi
```
Sprawdza, czy podano argument URL. Jeśli `$1` (pierwszy argument) jest pusty, wyświetla komunikat o prawidłowym użyciu skryptu i kończy jego działanie z kodem wyjścia 1.

```bash
# Define URL and output file
URL="$1"
OUTPUT_FILE="url_analysis_output.txt"
```
Definiuje zmienne `URL` i `OUTPUT_FILE`. `URL` przyjmuje wartość pierwszego argumentu, a `OUTPUT_FILE` to plik, w którym zostaną zapisane wyniki analizy.

```bash
# Clear the output file if it exists
> "$OUTPUT_FILE"
```
Czyści zawartość pliku wynikowego `OUTPUT_FILE`, jeśli istnieje.

```bash
echo "Analyzing URL: $URL" | tee -a "$OUTPUT_FILE"
```
Wyświetla komunikat "Analyzing URL" z podanym `URL` i dodaje go do pliku `OUTPUT_FILE` przy użyciu `tee`.

### Sekcja 1: Pobieranie nagłówków HTTP za pomocą `curl`

```bash
# Fetch only HTTP headers with curl
echo -e "\n=== HTTP Headers (curl -I) ===" | tee -a "$OUTPUT_FILE"
curl -I "$URL" >> "$OUTPUT_FILE" 2>&1
```
Wypisuje sekcję nagłówków HTTP. `curl -I` pobiera tylko nagłówki HTTP, a wynik jest zapisywany w pliku `OUTPUT_FILE`.

### Sekcja 2: Podążanie za przekierowaniami i pobieranie treści za pomocą `curl`

```bash
# Follow redirects and get the final content with curl
echo -e "\n=== Follow Redirects and Fetch Content (curl -L) ===" | tee -a "$OUTPUT_FILE"
curl -L "$URL" >> "$OUTPUT_FILE" 2>&1
```
Dodaje sekcję, która pokazuje, jak `curl` podąża za przekierowaniami. Opcja `-L` sprawia, że `curl` podąża za przekierowaniami i pobiera ostateczną zawartość strony.

### Sekcja 3: Zapis zawartości strony do pliku

```bash
# Save the content of the page to a file with curl
echo -e "\n=== Save Content to File (curl -o page_content.html) ===" | tee -a "$OUTPUT_FILE"
curl -o page_content.html "$URL" >> "$OUTPUT_FILE" 2>&1
echo "Content saved to page_content.html" | tee -a "$OUTPUT_FILE"
```
Pobiera zawartość strony i zapisuje ją do pliku `page_content.html` przy użyciu opcji `-o`. Dodaje informację o lokalizacji zapisanego pliku do `OUTPUT_FILE`.

### Sekcja 4: Wyświetlenie pełnej odpowiedzi (nagłówki + zawartość) za pomocą `curl`

```bash
# Display full response (headers + content) with curl
echo -e "\n=== Full Response (curl) ===" | tee -a "$OUTPUT_FILE"
curl "$URL" >> "$OUTPUT_FILE" 2>&1
```
Pobiera pełną odpowiedź od serwera, w tym nagłówki i zawartość strony, i zapisuje ją w `OUTPUT_FILE`.

### Sekcja 5: Ustawienie niestandardowego User-Agent za pomocą `curl`

```bash
# Customize User-Agent with curl
echo -e "\n=== Custom User-Agent (curl -A) ===" | tee -a "$OUTPUT_FILE"
curl -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64)" "$URL" >> "$OUTPUT_FILE" 2>&1
```
Przy użyciu `curl -A` ustawia niestandardowy nagłówek User-Agent, aby symulować przeglądarkę Windows, i zapisuje odpowiedź w `OUTPUT_FILE`.

### Sekcja 6: Sprawdzenie dostępności URL za pomocą `wget`

```bash
# Check if URL is accessible with wget
echo -e "\n=== URL Accessibility Check (wget --spider) ===" | tee -a "$OUTPUT_FILE"
wget --spider "$URL" >> "$OUTPUT_FILE" 2>&1
```
`wget --spider` sprawdza, czy URL jest dostępny bez pobierania zawartości i zapisuje wynik w `OUTPUT_FILE`.

### Sekcja 7: Pobranie zawartości URL za pomocą `wget`

```bash
# Download content of the URL with wget
echo -e "\n=== Download Content (wget) ===" | tee -a "$OUTPUT_FILE"
wget "$URL" -O wget_page_content.html >> "$OUTPUT_FILE" 2>&1
echo "Content saved to wget_page_content.html" | tee -a "$OUTPUT_FILE"
```
Pobiera stronę za pomocą `wget` i zapisuje jej zawartość do pliku `wget_page_content.html`.

### Sekcja 8: Rekurencyjne pobieranie z URL za pomocą `wget`

```bash
# Download with recursive depth using wget
echo -e "\n=== Recursive Download (wget -r -l 1) ===" | tee -a "$OUTPUT_FILE"
wget -r -l 1 "$URL" -P wget_recursive_content >> "$OUTPUT_FILE" 2>&1
echo "Recursive content saved to wget_recursive_content directory" | tee -a "$OUTPUT_FILE"
```
Rekurencyjnie pobiera stronę z głębokością 1, zapisując wyniki w katalogu `wget_recursive_content`.

### Sekcja 9: Niestandardowy User-Agent dla `wget`

```bash
# Set a custom User-Agent with wget
echo -e "\n=== Custom User-Agent (wget --user-agent) ===" | tee -a "$OUTPUT_FILE"
wget --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64)" "$URL" -O wget_user_agent_content.html >> "$OUTPUT_FILE" 2>&1
echo "Content saved to wget_user_agent_content.html" | tee -a "$OUTPUT_FILE"
```
Podobnie jak w `curl`, ustawia niestandardowy User-Agent dla `wget` i zapisuje zawartość w `wget_user_agent_content.html`.

### Sekcja 10: Pobranie wszystkich zasobów strony

```bash
# Download all resources from the URL with wget
echo -e "\n=== Download All Resources (wget -p) ===" | tee -a "$OUTPUT_FILE"
wget -p "$URL" -P wget_page_with_resources >> "$OUTPUT_FILE" 2>&1
echo "Page with resources saved to wget_page_with_resources directory" | tee -a "$OUTPUT_FILE"
```
`wget -p` pobiera stronę wraz z jej zasobami (np. obrazki, CSS) i zapisuje je w katalogu `wget_page_with_resources`.

```bash
# Finish
echo -e "\nAnalysis complete. Results saved to $OUTPUT_FILE."
```
Wyświetla końcowy komunikat informujący o zakończeniu analizy i zapisaniu wyników w `OUTPUT_FILE`.

Skrypt kompleksowo analizuje stronę, wykonując różne zadania przy użyciu `curl` i `wget`, a jego wyniki są zapisywane w `url_analysis_output.txt`. Wszystkie pliki wynikowe zapisywane są w źródłowej lokalizacji gotowe do pobrania i analizy:
![[Screenshot 2024-11-06 at 13.15.29.png]]
## Uruchomienie skryptu

1. Save this script to a file, e.g., `url_analysis.sh`.
2. Make it executable:
   ```bash
   chmod +x url_analysis.sh
   ```
3. Run it with a URL as an argument:
```bash
./url_analysis.sh http://example.com
```
