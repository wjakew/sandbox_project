# Open Source Sandbox Project
---
## Description
An simple and easy way for creating Sandbox Enviroment for testing, deploying and detonating maleware.
**The sandbox is still in creation - use carefully.**
## Project ovewiew
### Folders
1. scripts - all scripts for creating / testing and detonating in enviroment.
2. documentation - documentation for the project components
3. file server - simple web app for uploading files to the server
---
### Deployment instructions

1. Create a folder in the user directory for storing uploaded files and reports `mkdir uploads' and 'mkdir reports`
 save the absolute pathes for later. Open `nano clamav_monitor.sh` and set paths to storing and scanning with absolute pathes.

### Prepare ClamAV Enviroment
- Install package for creation notification:
```bash
sudo apt-get install inotify-tools  # Debian/Ubuntu
sudo yum install inotify-tools      # RHEL/CentOS
sudo dnf install inotify-tools      # Fedora
```
- Prepare default clamav configuration:
```bash
sudo cp /etc/clamav/clamd.conf.sample /etc/clamav/clamd.conf
sudo systemctl restart clamav-daemon
```

2. Set calmav_monitor.sh script to be executable with `sudo chmod +x calmav_monitor.sh`.
3. Create a service file for systemd using nano: `sudo nano /etc/systemd/system/clamav-monitor.service`
4. Add the following content:
```bash
[Unit]
Description=Monitor directory and scan new files with ClamAV
After=network.target

[Service]
Type=simple
ExecStart=<absolute path to clamav_monitor.sh>
Restart=always
User=<your username>
Group=<your user group>
WorkingDirectory=<your working directory>
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=clamav-monitor

[Install]
WantedBy=multi-user.target
```
5. Reload the systemd deamon and services:
```bash
sudo systemctl daemon-reload
sudo systemctl enable clamav-monitor.service
sudo systemctl start clamav-monitor.service
```
6. Check if service working `sudo systemctl status clamav-monitor.service`, you can check service logs with `journalctl -u clamav-monitor.service -f`
7. Download and install Java runtime, we suggesting openjdk 17 `sudo apt install openjdk-17-jdk-headless`.
8. Run DropIn website with `java -jar dropin.jar`, after first run the .properties file will be created. Fill the properties file with **password** and **absolute path to the folder for storing uploaded files**
After updating .properties file run the dropin service with following command (remember that
selected port should be allowed in/out TCP on firewall):
```bash
java -jar dropin.jar --server.port=<selected_port>
```
9. Run Takeit service with `java -jar takeit.jar`,
after first run the .properties file will be created. Fill the properties file with **password** and **absolute path to the folder for storing report files**
10. After updating .properties file run the dropin service with following command (remember that
selected port should be allowed in/out TCP on firewall):
```bash
java -jar takeit.jar --server.port=<selected_port>
```