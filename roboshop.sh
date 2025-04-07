#!/bin/bash

AMI_ID=ami-09c813fb71547fc4f
SG_ID=sg-04b7bd69af45641ab
ZONE_ID=Z01399073MOD2DFZHUJNU

INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "web")

#INSTANCES=("mongodb" "redis" "mysql" "web")

for i in "${INSTANCES[@]}"
do
    if
        [ $i == "mongodb" ] || [ $i == "mysql" ] || [ $i == "shipping" ]
    then    
        INSTANCE_TYPE=t3.small
    else
        INSTANCE_TYPE=t2.micro  
    fi
    # PRIVATE_IP=$(aws ec2 run-instances --image-id $AMI_ID --instance-type $INSTANCE_TYPE --security-group-ids $SG_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" --query 'Instances[0].PrivateIpAddress' --output text)

    # Run instances and capture instance IDs
    INSTANCE_IDS=$(aws ec2 run-instances --image-id $AMI_ID --instance-type $INSTANCE_TYPE --security-group-ids $SG_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" --query 'Instances[*].InstanceId' --output text)

    # Loop through each instance ID and retrieve its public IP address
    for INSTANCE_ID in $INSTANCE_IDS; do
        PUBLIC_IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[*].Instances[*].PublicIpAddress' --output text)
        #echo "Instance ID: $INSTANCE_ID, Public IP: $PUBLIC_IP"
    done

    # Loop through each instance ID and retrieve its public IP address
    for INSTANCE_ID in $INSTANCE_IDS; do
        PRIVATE_IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[*].Instances[*].PrivateIpAddress' --output text)
        #echo "Instance ID: $INSTANCE_ID, Public IP: $PUBLIC_IP"
    done

    echo "$i : Private IP: $PRIVATE_IP"
    echo "$i : Public IP: $PUBLIC_IP"

    if [ "$i" == "web" ]; then
    RECORD_VALUE=$PUBLIC_IP
    else
        RECORD_VALUE=$PRIVATE_IP
    fi

    aws route53 change-resource-record-sets \
    --hosted-zone-id $ZONE_ID \
    --change-batch '
    {
        "Comment": "Creating Route 53 Record"
        ,"Changes": [{
        "Action"              : "UPSERT"
        ,"ResourceRecordSet"  : {
            "Name"              : "'$i'.devopsprocloud.in"
            ,"Type"             : "A"
            ,"TTL"              : 1
            ,"ResourceRecords"  : [{
                "Value"         : "'$RECORD_VALUE'"
            }]
        }
        }]
    }'
done


