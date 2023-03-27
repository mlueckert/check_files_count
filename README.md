# check_files_count

Nagios filecount check (Bash Script)

## Example output

```bash
bash /tmp/check_files_count.sh -p "/usr/sap/" -f "\.hprof$" -w 5 -c 10
CRITICAL - 14 files found matching "\.hprof$" in "/usr/sap/". Use the following command to get the filesizes: ls -lh -R "/usr/sap/" [PIPE] grep -e "\.hprof$" | count=14;5;10;;
```
