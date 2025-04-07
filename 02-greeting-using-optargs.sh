#!/bin/bash

NAME=""
WISHES=""

USAGE (){
    echo "Command:: $(basename $0) -n <name> -w <wishes>"
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

echo "Hello $NAME. $WISHES."

