#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

source_dir="/tmp/shellscript-logs"

if [ ! -d $source_dir ]
then
    echo -e "$R Directory $source_dir does not exist $N."
    exit 1
fi

if [ -z "$(ls -A "$source_dir")" ];  
then
    echo -e "$R The directory $source_dir is Empty $N."
    exit 1
fi

FILES_TO_DELETE=$(find $source_dir -type f -mtime +14 -name "*.log")

while IFS= read -r line 
do 
    echo -e "Deleting $Y $line $N"
    rm -rf $line
done <<< $FILES_TO_DELETE

