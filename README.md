# SIMPLE ANTIVIRUS DAEMON

## OVERVIEW
this project is a simple antivirus daemon written in bash. it periodically checks a directory for changes, and when a change is detected, scans the directory for files it considers malicious. malicious files are flagged, printed to the terminal, quarantined into a separate directory, and removed from the original location. there is a restore tool that lets the user pick quarantined files from a list, one at a time, and decide whether each one was falsely flagged or genuinely malicious.

*PSA -- this project was built to handle directories with files directly inside them, no subdirectories at all.*

### FOLDER HIERARCHY
```
.
├── Makefile         
├── README.md
├── antivirus-cron.sh            
├── antivirusd.sh      
└── restore.sh
```

### PREREQUISITES
to execute the automation commands on an ubuntu system, the `make` utility must be installed. to do so, run the following commands in your terminal:
```
sudo apt update
sudo apt install make
```

### INSTRUCTIONS
1. in your terminal, run `make setup` to automatically create both the monitored and malicious directories
2. in your terminal, run `make daemon`, this creates the quarantine folder if it's missing, grant execution permission, and start the continuous monitoring script
3. to review the quarantined files, open a separate second terminal and run `make restore`, you will be prompted to choose a quarantined file, and you get to choose whether to restore it back to its original directory, permanently delete it or leave it in quarantine

### FLAGGED-EXTENSIONS & FLAGGED-KEYWORDS
a file is considered malicious if it matches at least one of the following rules:
1. flagged extensions: file's extension matches one of the following, hardcoded exactly as written: `.exe, .bat, .vbs, .scr, .ps1`
-> these are defined in the daemon script, inside the scanning function, the first if condition
2. flagged keywords: file's contents contain one of the following keywords (case-insensitive), hardcoded exactly as written: `virus, trojan, malware, worm, ransomware`
-> these are defined in the daemon script, inside the scanning function, the first and only else if condition

### BONUS FEATURES
#### 1. CRON JOB
##### PREREQUISITES
before anything, ensure the system's cron service is active and the script has the correct permissions:
1. installing the cron service:
```
sudo apt update
sudo apt install cron
```
2. enabling and starting the service (so it runs continuously in the background):
```
sudo systemctl enable --now cron
```
3. make the script executable:
```
chmod +x antivirus-cron.sh
```
##### CONFIGURATION
native linux `cron` only schedules down to the minute, a built-in `sleep` command is used to delay execution  by exactly 23 seconds, you achieve this by:
1. open the cron table by running `crontab -e` in the terminal
2. when prompted to pick an editor, type the number for `nano` and press `enter`
3. scroll to the very bottom of the configuration file and add the following line, as cron requires absolute paths to locate scripts and directories in the background:
```
* * * * * sleep 23 && /your/absolute/path/antivirus-cron.sh /your/absolute/path/dir /your/absolute/path/malicious_dir
```
4. save by pressing `ctrl+O`, press `enter`, then `ctrl+X` to exit. upon exiting, you should see a message saying `crontab: installing new crontab`
5. if you'd like to turn off the cron scheduling, run `crontab -e`, scroll until the very end where you'll find the line you just wrote, add a `#` before it to comment it out, follow instruction 4 to save your changes

##### SCHEDULING: EVERY 3RD FRIDAY OF THE MONTH AT 12:31 AM
```
31 0 15-21 * * [ "$(date '+\%u')" = "5" ] && /your/absolute/path/antivirus-cron.sh /your/absolute/path/dir /your/absolute/path/malicious_dir
```
i know that looks crazy, so let's break it down:
1. `31 0` executes at 12:31 am, 31 is the minute, 0 is the hour (12 am in 24-hour format)
2. `15-21` represents the day of the month, as the 3rd friday of any month will fall somewhere between the 15th and the 21st
3. `[ "$(date '+\%u')" = "5" ]` is the day of the week enforcer, since standard cron treats the "day of month" and "day of week" fields as an OR condition if both are provided. so we set the "day of week" to * and using this inline bash test forces the script to execute *only* if the current day is friday (day #5)

#### 2. WHITELIST
when reviewing a quarantined file, and user deems it as a "false positive" or not malicious, the file is added to a permanent text file, so upon incoming scans, the daemon doesn't inaccurately flag it as malicious again, this information persists across runs of the daemon (still respected even if the antivirus is stopped and restarted). `restore.sh` appends the exact file name to a permanent text file named `whitelist.txt`, and during a scan `antivirusd.sh` uses `grep` to look for an exact line match of the file name inside `whitelist.txt`. if found -> skips the extension and keyword checks
