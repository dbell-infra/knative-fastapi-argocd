#! /bin/bash

terraform_output=`cd ../aws && terraform output -json`

cluster_name=`echo $terraform_output | jq '.cluster_name.value' | tr -d '"' `

cluster_state_store_bucket=`echo $terraform_output | jq '.cluster_state_store.value' | tr -d '"' `

cluster_dns=`echo $terraform_output | jq '.cluster_dns.value' | tr -d '"' `

cluster_hostname="$cluster_name.$cluster_dns"

aws_region=`aws configure get region`

aws_az=`aws ec2 describe-availability-zones --region $aws_region`

rm zones

for i in 0 1 2
do 
    jq_str=.AvailabilityZones[$i].ZoneName
    echo $aws_az | jq $jq_str | tr -d '"' >> zones
done 

ZONES=`awk '{print $1}' zones | paste -s -d, -`
CLUSTER_STATE_BUCKET="s3://$cluster_state_store_bucket"

echo "Creating a highly available 3 node AWS cluster in $aws_region." 
echo "  Name: $cluster_hostname" 
echo "  AZs: $ZONES"

# sleep 5

kops create cluster \
    --node-count 3 \
    --zones $ZONES \
    --master-zones $ZONES \
    --networking cilium \
    --state $CLUSTER_STATE_BUCKET \
    --name $cluster_hostname

kops update cluster --name $cluster_hostname --yes --admin --state $CLUSTER_STATE_BUCKET

role_name="masters.$cluster_hostname"

echo $role_name

echo "adding ELB full access policy to kops master role"
aws iam attach-role-policy --policy-arn arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess --role-name $role_name
