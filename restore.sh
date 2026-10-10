#!/bin/bash

# assign command-line parameters to variables
dir=$1
malicious_dir=$2

echo "select a file to manage:"

while true; do
    if [ -z "$(ls -A "$malicious_dir")" ]; then # empty check
        echo "no malicious files to review"
        exit 0
    fi

    echo "CHOOSE A FILE:"

    counter=1
    for filepath in "$malicious_dir"/*; do
        echo "$counter: $(basename "$filepath")"
        ((counter++))
    done

    read -p "> " filenum

    found=false
    counter=1
    for filepath in "$malicious_dir"/*; do
        if [ "$counter" == "$filenum" ]; then
            found=true  
            quarantined=$(basename "$filepath")

            echo "for $quarantined:"
            echo "1: restore file back into dir"
            echo "2: permanently delete file from malicious_dir"
            echo "3: go back"
            read -p "> " choice
        
            if [ "$choice" == "1" ]; then
                cp "$filepath" "$dir"
                rm "$filepath"
                echo "restored $quarantined to $dir"
                echo "$quarantined" >> whitelist.txt 
            elif [ "$choice" == "2" ]; then
                rm "$filepath"
                echo "$quarantined permanently deleted"
            elif [ "$choice" == "3" ]; then
                break
            else
                echo "invalid choice. please try again."
            fi
            break
        fi
        ((counter++))    
    done
    if [ "$found" = false ]; then
        echo "invalid selection. please try again."
    fi
done
