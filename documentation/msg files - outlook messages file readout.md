In Kali Linux, you can read `.msg` files (Microsoft Outlook email files) by using several methods. Kali doesn't have a default tool specifically for `.msg` files, but here are a few approaches you can try:

### 1. Use `pff-tools`
`pff-tools` includes utilities like `pffexport` and `pffinfo` that can read `.msg` files.

1. Install `pff-tools` by running:
   ```bash
   sudo apt update
   sudo apt install pff-tools
   ```

2. Use `pffexport` to extract the contents of the `.msg` file to a readable format:
   ```bash
   pffexport -t <output_directory> <file.msg>
   ```

   This will convert the `.msg` file into a format that you can open with a text editor.

3. To get basic info about the file, you can use `pffinfo`:
   ```bash
   pffinfo <file.msg>
   ```

### 2. Use `catdoc` for Basic Text Extraction
`catdoc` can read Microsoft Office formats but might not fully support `.msg`. It may give partial output if the message contains only plain text.

1. Install `catdoc`:
   ```bash
   sudo apt install catdoc
   ```

2. Try extracting text:
   ```bash
   catdoc <file.msg>
   ```

### 3. Use `msgconvert` with `perl`
You can use the `msgconvert` Perl script to convert `.msg` files to `.eml` format.

1. Install `libemail-outlook-message-perl`:
   ```bash
   sudo apt update
   sudo apt install libemail-outlook-message-perl
   ```

2. Convert the `.msg` file to `.eml`:
   ```bash
   msgconvert <file.msg>
   ```

3. Once converted to `.eml`, open it in a text editor or email client like Thunderbird.

### 4. Open `.eml` Files in Thunderbird (optional)
If you converted the `.msg` file to `.eml`, you can open it directly with Thunderbird by installing it:

```bash
sudo apt install thunderbird
```

Then open Thunderbird, go to "File" -> "Open Saved Message" and select the `.eml` file.

These methods should help you view `.msg` email contents in Kali Linux. Let me know if you encounter any issues with these steps!