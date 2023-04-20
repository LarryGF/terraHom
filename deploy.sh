#! /bin/bash
ansible-playbook ./ansible/site.yml -i ./ansible/inventory/deploy/hosts.ini 
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.11.0/cert-manager.crds.yaml
kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v2.9/docs/content/reference/dynamic-configuration/kubernetes-crd-definition-v1.yml
terraform-docs markdown table --output-file README.md --output-mode inject terraform
cd terraform && \
rm -f *.tfstate* && \
terraform init && \
terraform plan -out plan -var 'modules_to_run=["adguard","cert-manager","duckdns","traefik","longhorn"]' &&\
terraform apply -auto-approve && \
terraform plan -out plan &&\
terraform apply -auto-approve