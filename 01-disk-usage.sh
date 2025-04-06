#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

disk_usage=$(df -hT | grep 'xvd')
threshold=1
message=""

while IFS= read -r line
do
    current_usage=$(echo $line | awk {'print $6F'} | cut -d % -f1)
    disk_partition=$(echo $line | awk {'print $1F'})
    if [ $current_usage -gt $threshold ]
    then            
        message+="High Disk Usage on $disk_partition: $current_usage % <br>"
    fi
done <<< $disk_usage

echo -e "$message"

# sh mail.sh "TO_TEAM" "SUBJECT" "ALERT_TYPE" "BODY" "TO_ADDRESS"
# we are passing the arguments to mail.sh commands
sh mail.sh "DevOps Team" "Systems | High Disk Usage" "High Disk Usage" "$message" "premsagar.eri@devopsprocloud.in"

#sh mail.sh "Backup and Storage Team" "SYSTEMS | High Storage Usage" "Storage Alert" "Find the below disk's <br> Disk 1: 95% <br> Disk 2: 96%" "premsagar.eri@devopsprocloud.in"