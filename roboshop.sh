#!/bin/bash

AMI_ID=ami-09c813fb71547fc4f
SG_ID=sg-04b7bd69af45641ab

INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "web")

for i in "${INSTANCES[@]}"
do
    if
        [ $i == "mongodb" ] || [ $i == "mysql" ] || [ $i == "shipping" ]
    then    
        INSTANCE_TYPE=t3.small
    else
        INSTANCE_TYPE=t2.micro  
    fi
    IP_ADDRESS=$(aws2 ec2 run-instances --image-id $AMI_ID --instance-type $INSTANCE_TYPE --security-group-ids $SG_ID --region us-east-1 --tag-specifications "ResourceType=instance,Tags={Key=Name,Value=$i}" --query 'Insances[0].PrivateIpAddress' --output text)
    echo "$i : $IP_ADDRESS"
done


#Trying

