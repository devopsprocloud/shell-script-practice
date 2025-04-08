#!/bin/bash

source_dir=""
action=""
destination_dir=""
time=14
memory=""
FILES=$(find $source_dir -type f -name "*.log")
archive_name=archive.zip

USAGE (){
    echo "OPTIONS: $(basename $0) -s <source-dir> -a <archive|delete> -d <destination> -t <day> -m <memory-in-mb>"
    echo "USAGE"
    echo "  -s, please enter the source directory (mandotory)"
    echo "  -a, select action either "archive" or "delete" (mandotory)"
    echo "  -d, enter the destination directory if -a is archive,, otherwise optional"
    echo "  -t, please enter the number of days (optional). Default value is 14 days"
    echo "  -s, please enter the memory-in-mb (optional)"
    echo "  -h, display help and exit"
}

while getopts ":s:a:d:t:m:h" opt;
do 
    case $opt in 
    s) source_dir="$OPTARG";;
    a) action="$OPTARG";;
    d) destination_dir="$OPTARG";;
    t) time="$OPTARG";;
    m) memory="$OPTARG";;
    h) USAGE; exit;;
    \?) echo "Invalid option: -$OPTARG"; USAGE; exit;;
    *) echo "Invalid option: -$OPTARG"; USAGE; exit;;
    esac
done

if [ ! -d $source_dir ];
then
    echo -e "Directory $source_dir does not exist."
    USAGE
    exit 1
fi

if [ -z "$source_dir" ] || [ -z "$action" ]
then 
    echo " -s and -a options are mandotory"
    USAGE
    exit
fi

if [ "$action" == "archive" ] && [ -z "$destination_dir" ];
then    
    echo " -d <destination> is mandatory when -a <action> is archive"
    USAGE
    exit
else 
    while IFS= read -r line
    do
    zip -r "$destination_dir/$archive_name" "$source_dir"
    if [ $? == 0 ]
    then
        echo "archiving the file $line"
    else
        echo "archiving the $line is failed"
    done <<< $FILES
fi

if [ ! -d $destination_dir ];
then
    echo -e "Directory $destination_dir does not exist."
    exit 1
fi

if [ "$action" == "delete" ];
then    
echo "Deleting the files older than $time days"
exit
fi




