#!/bin/bash

NAME=""
WISHES="Good Morning"

USAGE (){
    echo "USAGE:: $(basename $0) -n <name> -w <wishes>"
    echo "OPTIONS::"
    echo "  -n, please specify the name (mandotory)"
    echo "  -w, please specify the wishes (optional), Default value is: Good Morning"
    echo "  -h, display Help and exit"
}

while getopts ":n:w:h" opt; 
do
    case $opt in 
    n) NAME="$OPTARG";;
    w) WISHES="$OPTARG";;
    h) USAGE; exit;;
    \?) echo "Invalid option: -$OPTARG"; USAGE; exit;;
    *) echo "Invalid option: -$OPTARG"; USAGE; exit;;
    esac
done

# if [ -z $NAME ] || [ -z $WISHES ]
# then
#     echo "Both options -n and -w is mandatory"
#     USAGE
#     exit
# else
#     echo "Hello $NAME. $WISHES."
# fi

if [ -z $NAME ] 
then
    echo "Option -n is mandatory"
    USAGE
    exit
else
    echo "Hello $NAME. $WISHES."
fi

