#! /bin/bash
user=${PI_USER:- pi}
ansible-playbook ./ansible/k3s-ansible/reset.yml -i ./ansible/k3s-ansible/inventory/deploy/hosts.ini -u $user 
cd terraform && rm *tfstate*