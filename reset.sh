#! /bin/bash
user=${PI_USER:- pi}
ansible-playbook ./ansible/reset.yml -i ./ansible/inventory/deploy/hosts.ini -u $user 
cd terraform && rm *tfstate*