#! /bin/bash
user=${PI_USER:- pi}
printf "Running ansible playbook\n"
printf "You will be running this as ${PI_USER}\nType your password below:\n"
ansible-playbook ./ansible/site.yml -i ./ansible/inventory/deploy/hosts.ini --ask-become-pass --user $user
printf "Ansible playbook complete\n"
# printf "Scaling down kube-system pods\n"
# . ./scripts/scale_down.sh "-n kube-system" 0

printf "Scaling up  kube-system pods services and waiting for completion\n"

printf "CoreDNS\n"
kubectl -n kube-system scale deployment coredns --replicas=1
kubectl wait -n kube-system deployment/coredns --for=condition=available --timeout=5m
kubectl wait -n kube-system pods -l k8s-app="kube-dns" --for=condition=ready --timeout=5m
printf "Local Path Provisioner\n"
kubectl -n kube-system scale deployment local-path-provisioner --replicas=1
kubectl wait -n kube-system deployment/local-path-provisioner --for=condition=available --timeout=5m
kubectl wait -n kube-system pods -l app="local-path-provisioner" --for=condition=ready --timeout=5m
printf "Metrics Server\n"
kubectl -n kube-system scale deployment metrics-server --replicas=1
kubectl wait -n kube-system deployment/metrics-server --for=condition=available --timeout=5m
kubectl wait -n kube-system pods -l k8s-app=metrics-server --for=condition=ready --timeout=5m

printf "Installing CRDs\n"
# kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.11.0/cert-manager.crds.yaml
kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v2.9/docs/content/reference/dynamic-configuration/kubernetes-crd-definition-v1.yml
terraform-docs markdown table --output-file README.md --output-mode inject terraform
rm -f terraform/*.tfstate* && \
terraform init && \
terraform plan -out plan -vars 'modules_to_run=["adguardhome","duckdns","longhorn"]' -chdir=terraform && \
terraform apply plan && \
terraform plan -out plan -vars 'modules_to_run=["adguardhome","duckdns","longhorn","grafana","promtail","prometheus"]' -chdir=terraform && \
terraform apply plan && \
terraform plan -out plan -chdir=terraform && \
terraform apply plan
