#!/bin/bash

source_dir=""
action=""
destination_dir=""
time=14
memory=""

USAGE (){
    echo "USAGE:: $(basename $0) -s <source-dir> -a <action archive|delete> -d <destination-dir> -t <days> -m <memory-in-mb>"
    echo "Options::"
    echo "  -s, specify the source directory (mandotory)"
    echo "  -a, specify action: archive or delete (mandotory)"
    echo "  -d, specify the destination directory if -a is "archive". This is optional when -a is "delete""
    echo "  -t, specify the number of dates (Optiona). default value is 14 days"
    echo "  -m, specify the memory in mb (Optiona)"
    echo "  -h, display this help and exit" 
}

if [ $# -eq 0 ]; 
then
    echo "ERROR: Please provide the options, find the below usage"
    USAGE
    exit
fi

while getopts ":s:a:d:t:m:h" opt;
do 
    case $opt in
        s) source_dir="$OPTARG";;
        a) action="$OPTARG";;
        d) destination_dir="$OPTARG";;
        t) time="$OPTARG";;
        m) memory="$OPTARG";;
        h) USAGE; exit;;
        \?) echo "ERROR: Invalid Option: -$OPTARG"; USAGE; exit;
    esac
done

#-------------------------------------------------------------------

if [ ! -d $source_dir ];
then
    echo "ERROR: source $source_dir does not exist"
fi 

#-------------------------------------------------------------------

if [ -z "$source_dir" ] && [ -z "$action" ];
then    
    echo "ERROR: -d, and -a, options are mandotory"
    USAGE
    exit
fi 

#--------------------------------------------------------------------

if [ $action == "archive" ] && [ -z "$destination_dir" ] || [ ! -d $destination_dir ];
then 
    echo "ERROR:: -d, is mandotory when -a, is archive"
fi