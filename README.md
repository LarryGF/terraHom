Add cgroup_memory=1 cgroup_enable=memory /boot/cmdline.txt

helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
kubectl create namespace cattle-system
helm repo add jetstack https://charts.jetstack.io

helm repo update

helm install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --set installCRDs=true

helm install rancher rancher-latest/rancher -n cattle-system -f helm/rancher-values.yaml --create-namespace
kubectl get secret --namespace cattle-system bootstrap-secret -o go-template='{{.data.bootstrapPassword|base64decode}}{{"\n"}}'



#############################################
https://rancher.com/docs/os/v1.x/en/installation/server/raspberry-pi/
https://github.com/rancher/os/releases/tag/v1.5.5




# Troubleshooting
Error: INSTALLATION FAILED: create: failed to create: Internal error occurred: failed calling webhook "rancher.cattle.io": Post "https://rancher-webhook.cattle-system.svc:443/v1/webhook/mutation?timeout=10s": service "rancher-webhook" not found
kubectl delete -n cattle-system MutatingWebhookConfiguration rancher.cattle.io

## Doing an upgrade and username and password not working
kubectl -n cattle-system exec $(kubectl -n cattle-system get pods -l app=rancher | grep '1/1' | head -1 | awk '{ print $1 }') -- reset-password
kubectl  -n cattle-system exec $(kubectl -n cattle-system get pods -l app=rancher | grep '1/1' | head -1 | awk '{ print $1 }') -- ensure-default-admin
