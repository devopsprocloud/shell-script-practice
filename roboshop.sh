#!/bin/bash

AMI_ID=ami-09c813fb71547fc4f
SG_ID=sg-04b7bd69af45641ab

#INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "web")

INSTANCES=("mongodb" "redis" "mysql" "web")

for i in "${INSTANCES[@]}"
do
    if
        [ $i == "mongodb" ] || [ $i == "mysql" ] || [ $i == "shipping" ]
    then    
        INSTANCE_TYPE=t3.small
    else
        INSTANCE_TYPE=t2.micro  
    fi
    PRIVATE_IP_ADDRESS=$(aws ec2 run-instances --image-id $AMI_ID --instance-type $INSTANCE_TYPE --security-group-ids $SG_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" --query 'Instances[0].PrivateIpAddress' --output text)

    PUBLIC_IP_ADDRESS=$(aws ec2 describe-instances --query 'Reservations[*].Instances[*].PublicIpAddress' --output text)

    echo "$i : $PRIVATE_IP_ADDRESS"
    echo "$i : $PUBLIC_IP_ADDRESS"

done


#Trying

