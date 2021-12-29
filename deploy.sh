#! /bin/bash
user=${PI_USER:- pi}
ansible-playbook ./ansible/k3s-ansible/site.yml -i ./ansible/k3s-ansible/inventory/deploy/hosts.ini -u $user -v
cd terraform && terraform init && terraform apply -auto-approve