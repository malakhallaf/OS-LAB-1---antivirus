# SIMPLE ANTIVIRUS DAEMON

## OVERVIEW
this project is a simple antivirus daemon written in bash. it periodically checks a directory for changes, and when a change is detected, scans the directory for files it considers malicious. malicious files are flagged, printed to the terminal, quarantined into a separate directory, and removed from the original location. there is a restore tool that lets the user pick quarantined files from a list, one at a time, and decide whether each one was falsely flagged or genuinely malicious.

*PSA -- this project was built to handle directories with files directly inside them, no subdirectories at all.*

### FOLDER HIERARCHY
```
.
├── Makefile         
├── README.md         
├── antivirusd.sh      
└── restore.sh
```

#### PREREQUISITES
to execute the automation commands on an ubuntu system, the *make* utility must be installed. to do so, run the following commands in your terminal:
sudo apt update
sudo apt install make

#### INSTRUCTIONS
1. make sure the directory to be monitored exists in the same folder as the scripts (named dir)
2. in your terminal, run "make daemon", this creates the quarantine folder if it's missing, grant execution permission, and start the continuous monitoring script
3. to review the quarantined files, open a separate second terminal and run "make restore", you will be prompted to choose a quarantined file, and you get to choose whether to restore it back to its original directory, permanently delete it or leave it in quarantine

#### FLAGGED-EXTENSIONS & FLAGGED-KEYWORDS
a file is considered malicious if it matches at least one of the following rules:
1. flagged extensions: file's extension matches one of the following, hardcoded exactly as written: .exe, .bat, .vbs, .scr, .ps1.
-> these are defined in the daemon script, inside the scanning function, the first if condition
2. flagged keywords: file's contents contain one of the following keywords (case-insensitive), hardcoded exactly as written: virus, trojan, malware, worm, ransomware.
-> these are defined in the daemon script, inside the scanning function, the first and only else if condition