#!/bin/sh -xe

# Check inventory was done and inventory file created
if [ $(find /var/lib/ocsinventory-agent/ -name "*.ocs" | wc -l) -ne 1 ]; then
    echo "ERROR: The inventory report has not been created."
    exit 1
fi

find /var/lib/ocsinventory-agent/ -name "*.ocs" -print0 | xargs -0 -n1 xmllint > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "ERROR: The inventory report is not a well formed XML."
    exit 1
fi

 # Check cronjob creation
grep ocsinventory-agent /var/spool/cron/root > /dev/null 2>&1 || (echo "ERROR: Cronjob seems to not have been created." && exit 1)