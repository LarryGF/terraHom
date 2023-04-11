#! /bin/bash
user=${PI_USER:- pi}
ansible-playbook ./ansible/k3s-ansible/site.yml -i ./ansible/k3s-ansible/inventory/deploy/hosts.ini -u $user -v
kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v2.9/docs/content/reference/dynamic-configuration/kubernetes-crd-definition-v1.yml
cd terraform && terraform init && terraform apply -target helm_release.cert-manager && terraform apply 