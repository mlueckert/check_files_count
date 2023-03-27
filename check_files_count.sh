#!/bin/bash

# initialize variables
warn=10
crit=20

# parse arguments
while getopts ":p:f:w:c:" opt; do
  case $opt in
    p)
      path="$OPTARG"
      ;;
    f)
      filepattern="$OPTARG"
      ;;
    w)
      warn="$OPTARG"
      ;;
    c)
      crit="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 3
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 3
      ;;
  esac
done

# check if path and filepattern are specified
if [[ -z "$path" || -z "$filepattern" ]]; then
  echo "Usage: $0 -p <path> -f <filepattern> [-w <warning>] [-c <critical>]"
  echo "       -f <filepattern> must be a valid regex pattern. (e.g. \"\\.hprof\$\")"
  exit 3
fi

# check for invalid characters in path and filepattern
if [[ "$path" =~ [\|\'] || "$filepattern" =~ [\|\'] ]]; then
  echo "Error: path and filepattern cannot contain pipe or single quote characters"
  exit 3
fi

# count files
count=$(ls -R "$path" 2>/dev/null | grep -c -e "$filepattern")

# check for errors
if [[ $? -gt 1 ]]; then
  echo "UNKNOWN: Error counting files. ls return code is > 1."
  exit 3
fi

# set status based on count
if [[ $count -ge $crit ]]; then
  status="CRITICAL"
  exitcode=2
elif [[ $count -ge $warn ]]; then
  status="WARNING"
  exitcode=1
else
  status="OK"
  exitcode=0
fi

# output result in nagios format
echo "$status - $count files found matching \"$filepattern\" in \"$path\". Use the following command to get the filesizes: ls -lh -R \"$path\" | grep -e \"$filepattern\" |count=$count;$warn;$crit;;"
exit $exitcode
