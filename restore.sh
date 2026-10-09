#!/bin/bash

# assign command-line parameters to variables
dir=$1
malicious_dir=$2

echo "select a file to manage:"

while true; do
    select filepath in "$malicious_dir"/*; do
        if [ ! -f "$filepath" ]; then # empty check
            echo "no malicious files to review"
            exit 0
        fi
        if [ -n "$filepath" ]; then
            quarantined=$(basename "$filepath")
            echo "you selected: $quarantined"
            break
        else
            echo "invalid selection. please try again."
        fi
    done

    read -p "choose what to do with this file (1 -> restore into dir, 2 -> permanently delete, 3 -> stay quarantined):" choice
    if [ "$choice" == "1" ]; then
        cp "$filepath" "$dir"
        rm "$filepath"
        echo "restored $quarantined to $dir"
        echo "$quarantined" >> whitelist.txt 
    elif [ "$choice" == "2" ]; then
        rm "$filepath"
        echo "$quarantined permanently deleted"
    elif [ "$choice" == "3" ]; then
        continue
    else
        echo "invalid choice. please try again."
    fi
done
