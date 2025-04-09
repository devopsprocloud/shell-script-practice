#!/bin/bash

source_dir=""
action=""
destination_dir=""
time=14
memory=""

USAGE (){
    echo "USAGE: $(basename $0) -s  <source-dir> -a <action archive|delete> -d <destination-dir> -t <days> -m <memory-in-mb>"
    echo "Options:"
    echo "  -s, specify the source directory (mandotory)"
    echo "  -a, specify action: archive or delete (mandotory)"
    echo "  -d, specify the destination directory if -a is "archive". This is optional when -a is "delete""
    echo "  -t, specify the number of dates (Optiona). default value is 14 days"
    echo "  -m, specify the memory in mb (Optiona)"
    echo "  -h, display this help and exit" 
}

while getopts ":s:a:d:t:m:h" opt;
do 
    case $opt in
        s) source_dir="$OPTARG";;
        a) action="$OPTARG";;
        d) destination_dir="$OPTARG";;
        t) time="$OPTARG";;
        m) memory="$OPTARG";;
        h) help="$OPTARG";;
        \?) echo "ERROR: Invalid Option: -$OPTARG"; USAGE; exit
    esac
done