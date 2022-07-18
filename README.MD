# knative-fastapi-argocd

Utilize Argo CD to continuosly deploy a serverless application to a highly available Kubernetes cluster.

## Tooling 

- **Cloud Provider IAC**: Terraform

- **Kubernetes Cluster Provisioning**: kOps

- **CNI**: cillium

- **Project Bootstrapping**: bash:)

- **Continous Delivery**: ArgoCD

## Requirements:
1. An AWS Route53 hosted zone that you own
2. An aws user account with admin permissions
3. kOps cli
5. terraform
4. kubectl
5. kn (optional)
6. a unix shell with jq


## Steps: 

1. Clone this repo 
2. Enter into infrastructure/aws and terraform apply using your tfvars file
3. Enter into infrastructure/k8s and run the kops_install.sh script
4. run the knative_install.sh script




