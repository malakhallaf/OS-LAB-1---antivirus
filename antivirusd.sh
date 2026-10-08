#!/bin/bash

# assign command-line parameters to variables
MONITOR_DIR=$1
QUARANTINE_DIR=$2
INTERVAL=$3

scan_directory() {
    echo "scanning $MONITOR_DIR for malicious files..."
    #
}

scan_directory

ls -l "$MONITORR_DIR" > directory-info.last

while true; do
    sleep "$INTERVAL"
    ls -l "$MONITOR_DIR" > directory-info.new
    if ! cmp -s dirctory-info.last directory-info.new; then
        echo "change detected in directory!"
        scan_directory
        cp directory-info.new directory-info.last
    fi
done        