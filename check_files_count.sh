#!/bin/bash

# Define usage function
usage() {
    echo "Usage: $0 -p <path> -f <regex filepattern> [-w <warning>] [-c <critical>]"
    exit 1
}

# Parse arguments
while getopts ":p:f:w:c:" opt; do
    case $opt in
        p) path=$OPTARG ;;
        f) filepattern=$OPTARG ;;
        w) warning=$OPTARG ;;
        c) critical=$OPTARG ;;
        *) usage ;;
    esac
done

# Set default values for warning and critical if not provided
warning=${warning:-10}
critical=${critical:-20}

# Check if path and filepattern are provided
if [ -z "$path" ] || [ -z "$filepattern" ]; then
    usage
fi

# Check count of files matching the filepattern in the specified path and subfolders
count=$(ls -R $path 2>/dev/null | grep -c -G "$filepattern")

# Output nagios format message
if [ $count -ge $critical ]; then
    echo "CRITICAL: $count files found matching '$filepattern' in $path and subfolders | count=$count;$warning;$critical"
    exit 2
elif [ $count -ge $warning ]; then
    echo "WARNING: $count files found matching '$filepattern' in $path and subfolders | count=$count;$warning;$critical"
    exit 1
else
    echo "OK: $count files found matching '$filepattern' in $path and subfolders | count=$count;$warning;$critical"
    exit 0
fi
