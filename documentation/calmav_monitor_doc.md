Here’s the updated Bash script where each scan generates a new report file with a timestamped name. The report includes:
	•	Timestamp of when the scan started
	•	The name of the scanned file
	•	The full scan report from ClamAV

⸻

Script: clamav_monitor.sh

#!/bin/bash

# Define variables
WATCH_DIR="/home/user/downloads"   # Directory to monitor
REPORT_DIR="/home/user/scan_reports"  # Directory to save scan reports

# Ensure ClamAV is installed
if ! command -v clamscan &> /dev/null; then
    echo "ClamAV (clamscan) is not installed. Please install it first."
    exit 1
fi

# Check if the directories exist, create if not
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
freshclam

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



⸻

How This Works:
	1.	Monitors the directory for new files.
	2.	Creates a unique report every time a file is scanned:
	•	Filename: virus_scan_report_YYYY-MM-DD_HH-MM-SS.txt
	•	Stored in: /home/user/scan_reports
	3.	Includes the scan start time and file name at the beginning of each report.
	4.	Runs continuously to detect and scan new files.

⸻

How to Use:
	1.	Modify these variables in the script:

WATCH_DIR="/your/path/to/monitor"
REPORT_DIR="/your/path/to/store/reports"


	2.	Give execution permissions:

chmod +x clamav_monitor.sh


	3.	Run the script:

./clamav_monitor.sh



⸻

Example Output in Report:

📄 virus_scan_report_2025-03-09_15-30-45.txt

====== Virus Scan Report ======
Scan Start Time: Sun Mar  9 15:30:45 UTC 2025
Scanned File: /home/user/downloads/suspicious_file.exe
================================
/home/user/downloads/suspicious_file.exe: Infected with Trojan.Malware

----------- SCAN SUMMARY -----------
Known viruses: 8943201
Engine version: 0.105.2
Scanned files: 1
Infected files: 1
Time: 3.2 sec (3.2 sec)



⸻

Bonus Features (Optional Enhancements)
	•	🛑 Move infected files to quarantine
	•	📧 Email alert if a virus is found
	•	🔔 Desktop notifications on scan completion

Let me know if you need extra features! 🚀


---

You can run your Bash script in the background using various methods. Here are a few options:

⸻

1️⃣ Run in the Background with &

Simply append & to the command when running the script:

./clamav_monitor.sh &

	•	This will run the script in the background, but it will still be attached to the current terminal session.

⸻

2️⃣ Run in the Background and Detach Using nohup

nohup allows the script to keep running even after you close the terminal:

nohup ./clamav_monitor.sh > /dev/null 2>&1 &

	•	This will ignore hangup signals and prevent termination when you log out.
	•	The output is discarded (/dev/null), but if you want to log it, use:

nohup ./clamav_monitor.sh > script.log 2>&1 &



⸻

3️⃣ Use screen to Run in a Persistent Session

If your system has screen installed, you can create a separate session for the script:

screen -S clamav_monitor

Then, run:

./clamav_monitor.sh

	•	To detach the session: Press Ctrl + A, then D
	•	To reopen the session later:

screen -r clamav_monitor



⸻

4️⃣ Use tmux for a Persistent Session

If you use tmux, start a session:

tmux new -s clamav

Then run:

./clamav_monitor.sh

	•	To detach: Press Ctrl + B, then D
	•	To reopen later:

tmux attach -t clamav



⸻

5️⃣ Run as a System Service (Advanced)

If you want the script to run on boot and stay active as a service, create a systemd service.
	1.	Create a service file:

sudo nano /etc/systemd/system/clamav_monitor.service


	2.	Add the following content:

[Unit]
Description=ClamAV File Monitor
After=network.target

[Service]
ExecStart=/path/to/clamav_monitor.sh
WorkingDirectory=/home/user
StandardOutput=append:/home/user/clamav_monitor.log
StandardError=append:/home/user/clamav_monitor.log
Restart=always
User=username

[Install]
WantedBy=multi-user.target


	3.	Enable and start the service:

sudo systemctl daemon-reload
sudo systemctl enable clamav_monitor
sudo systemctl start clamav_monitor


	4.	Check the status:

systemctl status clamav_monitor



⸻

Which Method Should You Use?
	•	✅ For a quick background run: Use ./clamav_monitor.sh &
	•	✅ To keep it running after logout: Use nohup
	•	✅ For persistent monitoring: Use screen or tmux
	•	✅ To run on startup and auto-restart: Use systemd

Let me know if you need help setting up! 🚀
