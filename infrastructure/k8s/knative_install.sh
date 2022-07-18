#!/bin/bash

terraform_output=`cd ../aws && terraform output -json`
app_dns=`echo $terraform_output | jq '.app_dns.value' | tr -d '"' `
app_dns_id=`echo $terraform_output | jq '.app_dns_id.value' | tr -d '"' `

echo "Installing knative serving components"
kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.6.0/serving-crds.yaml

echo "Installing knative eventing components"
kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.6.0/serving-core.yaml

echo "Installing knative kourier"
kubectl apply -f https://github.com/knative/net-kourier/releases/download/knative-v1.6.0/kourier.yaml

kubectl patch configmap/config-network \
  --namespace knative-serving \
  --type merge \
  --patch '{"data":{"ingress-class":"kourier.ingress.networking.knative.dev"}}'

echo "waiting for kourier service"

until [ -n "$(kubectl get svc kourier -n kourier-system -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')" ]; do
    sleep 10
done

service_address=`kubectl get svc kourier -n kourier-system -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'`


echo "found service address $service_address"

echo "creating route53 record for knative apps"

cat << EOF > route53.json
{
    "Comment": "adding app wildcard mapping to kourier CNAME",
    "Changes": [
        {
            "Action": "UPSERT",
            "ResourceRecordSet": {
                "Name": "*.$app_dns.",
                "Type": "CNAME",
                "TTL": 300,
                "ResourceRecords": [
                    {
                        "Value": "$service_address"
                    }
                ]
            }
        }
    ]
}
EOF

aws route53 change-resource-record-sets --hosted-zone-id $app_dns_id --change-batch file://route53.json

echo "updating knative DNS config"

patch_data="{\"data\":{\"$app_dns\":\"\"}}"



kubectl patch configmap/config-domain \
  --namespace knative-serving \
  --type merge \
  --patch $patch_data