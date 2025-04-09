#!/bin/bash

source_dir=""
action=""
destination_dir=""
time=14
memory=""

USAGE () {
    echo "USAGE:: $(basename $0) -s <source-dir> -a <action archive|delete> -d <destination-dir> -t <days> -m <memory-in-mb>"
    echo "Options::"
    echo "  -s, specify the source directory (mandatory)"
    echo "  -a, specify action: archive or delete (mandatory)"
    echo "  -d, specify the destination directory if -a is 'archive'. This is optional when -a is 'delete'"
    echo "  -t, specify the number of days (Optional). default value is 14 days"
    echo "  -m, specify the memory in mb (Optional)"
    echo "  -h, display this help and exit"
}

if [ $# -eq 0 ]; then
    echo "ERROR: Please provide the options, find the below usage"
    USAGE
    exit 1
fi

while getopts ":s:a:d:t:m:h" opt; do
    case $opt in
        s) source_dir="$OPTARG";;
        a) action="$OPTARG";;
        d) destination_dir="$OPTARG";;
        t) time="$OPTARG";;
        m) memory="$OPTARG";;
        h) USAGE; exit;;
        \?) echo "ERROR: Invalid Option: -$OPTARG"; USAGE; exit 1;;
    esac
done

#-------------------------------------------------------------------

if [ ! -d "$source_dir" ]; then
    echo "ERROR: The source directory $source_dir does not exist. Please enter a valid directory"
    USAGE
    exit 1
fi

#-------------------------------------------------------------------

if [ -z "$source_dir" ] || [ -z "$action" ]; then
    echo "ERROR: -s and -a options are mandatory"
    USAGE
    exit 1
fi

#--------------------------------------------------------------------

if [ "$action" == "archive" ] && [ -z "$destination_dir" ]; then
    echo "ERROR: -d is mandatory when -a is archive"
    USAGE
    exit 1
fi
if [ "$action" == "archive" ] && [ ! -d "$destination_dir" ]; then
    echo "ERROR: The destination directory $destination_dir does not exist. Please enter a valid directory"
    USAGE
    exit 1
fi

#-----------------------------------------------------------------------------

if [ "$action" == "delete" ]; then
    FILES_TO_DELETE=$(find "$source_dir" -type f -mtime "$time" -name "*.log")

    if [ ! -f "$FILES_TO_DELETE" ]; then
        echo "No files to delete."
        exit 0
    fi

    while IFS= read -r line; do
        echo "Deleting the file $line"
        rm -rf "$line"
    done <<< "$FILES_TO_DELETE"
else
    FILES_TO_ARCHIVE=$(find "$source_dir" -type f -mtime "$time" -name "*.log")

    if [ -z "$FILES_TO_ARCHIVE" ]; then
        echo "There are no files to archive."
        exit 1
    fi

    zip -r "$destination_dir/archive.zip" $FILES_TO_ARCHIVE

    for file in $FILES_TO_ARCHIVE; do
        echo "Archived the file $file"
    done
fi
