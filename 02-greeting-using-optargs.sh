#!/bin/bash

NAME=""
WISHES=""

USAGE (){
    echo "Command:: $(basename $0) -n <name> -w <wishes>"
    echo "USAGE::"
    echo "  -n, please specify the name"
    echo "  -w, please specify the wishes. Ex: Good Morning"
    echo "  -h, Display Help and Exit"
}

while getopts ":n:w:h" opt; 
do
    case $opt in 
    n) NAME="$OPTARG";;
    w) WISHES="$OPTARG";;
    h) USAGE; exit;;
    \?) USAGE; exit;;
    esac
done

if [ -z $NAME ] || [ -z $WISHES ]
then
    echo "Both options -n and -w is mandatory"
else
    echo "Hello $NAME. $WISHES."
fi

