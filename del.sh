#!/bin/bash

source_dir=""
action=""
destination_dir=""
time=""
memory=""

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

    if [ ! -d $source_dir ]
    then
        echo -e "Directory $source_dir does not exist."
        USAGE
        exit 1
    fi

    if [ -z = $source_dir ] || [ -z = $action ]
    then 
        echo " -s and -a options are mandotory"
        USAGE
        exit
    fi

    if [ $action == "archive" ] && [ -z = $destination_dir ]
    then    
        echo " -d <destination> is mandatory when -a <action> is archive"
        USAGE
        exit
    fi

    if [ $archive == "delete" ]
    then    
    echo "Deleting the files older than 14 days"
    USAGE
        exit
    fi

done


