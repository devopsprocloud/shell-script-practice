#!/bin/bash

AMI=ami-09c813fb71547fc4f
SG=sg-04b7bd69af45641ab
ZONE_ID=Z01399073MOD2DFZHUJNU

INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "web")

for i in "${INSTANCES[@]}"
do
    if [ $i == "mongodb" ] || [ $i == "mysql" ] || [ $i == "shipping" ]
    then
        INSTANCE_TYPE=t3.small
    else
        INSTANCE_TYPE=t2.micro
    fi

    INSTANCE_IDS=$(aws ec2 run-instances --image-id $AMI --instance-type $INSTANCE_TYPE --security-group-ids $SG --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" --query 'Instances[0].InstanceId' --output text)

    for INSTANCE_ID in $$INSTANCE_IDS;
    do 
    PUBLIC_IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_IDS --query "Reservations[*].Instances[*].PublicIpAddress" --output text)
    done

    for INSTANCE_ID in $$INSTANCE_IDS;
    do 
    PRIVATE_IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_IDS --query "Reservations[*].Instances[*].PrivateIpAddress" --output text)
    done

    echo "$i: $PUBLIC_IP (Public IP),  $PRIVATE_IP (private IP)"

    if [ "$i" == "web" ]
    then
        RECORD_VALUE=$PUBLIC_IP
    else
        RECORD_VALUE=$PRIVATE_IP
    fi

    aws route53 change-resource-record-sets \
    --hosted-zone-id $ZONE_ID \
    --change-batch '
    {
        "Comment": "Creating Route 53 record set for '$i'"
        ,"Changes": [{
        "Action"              : "UPSERT"
        ,"ResourceRecordSet"  : {
            "Name"              : "'$i'.devopsprocloud.in"
            ,"Type"             : "CNAME"
            ,"TTL"              : 120
            ,"ResourceRecords"  : [{
                "Value"         : "'$RECORD_VALUE'"
            }]
        }
        }]
    }'
done