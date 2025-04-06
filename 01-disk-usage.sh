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
        message+="High Disk Usage on $disk_partition: $current_usage % \n"
    fi
done <<< $disk_usage

echo -e "$message"

