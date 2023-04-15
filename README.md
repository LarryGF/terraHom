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
  
## Automated Deployment

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

- Create `ansible/k3s-ansible/inventory/deploy/hosts.ini with the following:
  
    ```ini
      [master]
        master_ip
      [node]
        worker_node_ip

      [k3s:children]
      master
      node
    ```
  
  - You can always delete or comment (`; *`)depending on your setup 

- Create `terraform/terraform.tfvars` under the directory with the missing vars with the following:

  ```hcl
      letsencrypt_email="Your email"
      letsencrypt_server="Letsencrypt validation server, use staging at first"
      timezone = "Your timezone"
      duckdns_token = "Your token"
      duckdns_domains = "Your domain"
      source_range = "Allowed source range"
  ```

- Run:

    ```shell
    bash deploy.sh
    ```

## Manual Deployment (not recommended)

Alternatively you can deploy everything manually, but you will need to do it in the following order:

### Ansible

- From the root folder

## Terraform State Backups

There's a resource that every time you run `terraform apply` it will create a backup of the state file in the `./terraform/.backup` folder. It will be stored in the format `YYYY.MM.DD.HH.MM.terraform.tfstate.backup`. In case you run into any errors you can restore the state file from the backup by just copying it to the `./terraform` folder and renaming it to `terraform.tfstate`.

## Troubleshooting

### Terraform failed to create the resources during automated install

It's most likely that you have missing or wrong variables. Look at the output of the command, maybe you missed a module 😉.
If you're sure that you have all the correct variables, try to run the command again, it might be a temporary issue, this is still a work in progress and there might be race conditions that I haven't found yet.

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
