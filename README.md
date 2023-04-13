# Pi-k8s

Automated setup to install _k3s_ and some services on your Raspberry Pi

## Pre-deployment

- Flash Debian GNU/Linux 11 (bullseye) arm64 to the Raspberry Pi
- Connect the Raspberry Pi to your network
- Setup passwordless SSH access to the Pi (you will need an SSH keypair for this).

    ```shell
    ssh-copy-id pi@<NODE_IP>
    ```

- Create an account on duckdns.org
- Create your subdomain on duckdns.org, save your subdomain and your token
- Point your subdomain to your external IP address (this won't work if your public IP address is NATed by your ISP)
  - If your public IP is being NATed consider upgrading to a fixed IP address or modifying the values to deploy with celf signed certificates
  
## Deployment

- Create `ansible/k3s-ansible/inventory/deploy/group_vars/all.yml with the following:

    ```yaml
      ---
      k3s_version: v1.24.11+k3s1
      systemd_dir: /etc/systemd/system
      master_ip: "{{ hostvars[groups['master'][0]]['ansible_host'] | default(groups['master'][0]) }}"
      extra_server_args: "--disable=traefik"
      extra_agent_args: ""
      timezone: 'Your timezone'
      allowed_ssh_networks:
          - network1
          - network2
    ```

- Create `terraform/terraform.tfvars` under the directory with the missing vars with the following:

  ```hcl
      letsencrypt_email="Your email"
      timezone = "Your timezone"
      duckdns_token = "Your token"
      duckdns_domains = "Your domains"
  ```

- Run:

    ```shell
    bash deploy.sh
    ```

- Alternatively,

## Troubleshooting

Error: INSTALLATION FAILED: create: failed to create: Internal error occurred: failed calling webhook "rancher.cattle.io": Post "https://rancher-webhook.cattle-system.svc:443/v1/webhook/mutation?timeout=10s": service "rancher-webhook" not found
kubectl delete -n cattle-system MutatingWebhookConfiguration rancher.cattle.io

## Doing an upgrade and username and password not working

kubectl -n cattle-system exec $(kubectl -n cattle-system get pods -l app=rancher | grep '1/1' | head -1 | awk '{ print $1 }') -- reset-password
kubectl  -n cattle-system exec $(kubectl -n cattle-system get pods -l app=rancher | grep '1/1' | head -1 | awk '{ print $1 }') -- ensure-default-admin

### Manual install (deprecated)

<https://rancher.com/docs/os/v1.x/en/installation/server/raspberry-pi/>
<https://github.com/rancher/os/releases/tag/v1.5.5>

helm repo add rancher-latest <https://releases.rancher.com/server-charts/latest>

kubectl create namespace cattle-system

helm repo add jetstack <https://charts.jetstack.io>

helm repo update

helm install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --set installCRDs=true

helm install rancher rancher-latest/rancher -n cattle-system -f helm/rancher-values.yaml --create-namespace
kubectl get secret --namespace cattle-system bootstrap-secret -o go-template='{{.data.bootstrapPassword|base64decode}}{{"\n"}}'
