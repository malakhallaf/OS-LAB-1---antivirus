#!/bin/bash

# assign command-line parameters to variables
dir=$1
malicious_dir=$2
interval_secs=$3

scan_directory() {
    echo "scanning $dir for malicious files..."
    for filepath in "$dir"/*; do
    [ -f "$filepath" ] || continue # not regular file -> continue to next loop iteration
    filename=$(basename "$filepath")
        if [ -f "whitelist.txt" ] && grep -F -x -q "$filename" "whitelist.txt"; then continue
        elif [[ "$filepath" == *.exe || "$filepath" == *.bat || "$filepath" == *.vbs || "$filepath" == *.scr || "$filepath" == *.ps1 ]]; then
            echo "$filepath is malicious and it is DELETED"
            cp "$filepath" "$malicious_dir"
            rm "$filepath"
        elif grep -iE -q "virus|trojan|malware|worm|ransomware" "$filepath"; then
            echo "$filepath is malicious and it is DELETED"
            cp "$filepath" "$malicious_dir"
            rm "$filepath"
        fi    
    done     
}

scan_directory

ls -l "$dir" > directory-info.last

while true; do
    sleep "$interval_secs"
    ls -l "$dir" > directory-info.new
    if ! cmp -s directory-info.last directory-info.new; then
        echo "change detected in directory!"
        scan_directory
        ls -l "$dir" > directory-info.last
    fi
done        