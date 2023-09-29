# Pi-k8s

\*Mostly\* Automated setup to install _k3s_ and additional services on your home cluster.

## Table of Contents

- [Pi-k8s](#pi-k8s)
  - [Table of Contents](#table-of-contents)
  - [Terminology](#terminology)
  - [Pre-deployment](#pre-deployment)
    - [Basic node setup](#basic-node-setup)
      - [Control Node](#control-node)
      - [Managed Nodes](#managed-nodes)
        - [Domain and public IP](#domain-and-public-ip)
    - [Storage](#storage)
    - [VPN Setup](#vpn-setup)
      - [Obtaining the VPN config](#obtaining-the-vpn-config)
  - [Automated Deployment](#automated-deployment)
    - [Ansible](#ansible)
    - [Terraform](#terraform)
  - [ArgoCD](#argocd)
  - [Manual Deployment (not recommended)](#manual-deployment-not-recommended)
    - [Ansible](#ansible-1)
    - [Longhorn](#longhorn)
  - [Troubleshooting](#troubleshooting)
  - [Expanding the repo](#expanding-the-repo)
  - [General knowledge](#general-knowledge)
    - [Kubectl](#kubectl)
  - [Uninstalling](#uninstalling)
    - [Uninstall Longhorn](#uninstall-longhorn)
  - [Adult Content](#adult-content)
  - [TODO](#todo)

## Terminology

- Control Node: This is your local computer, you will be running most of the actions from here
- Managed Nodes: These will be your Kubernetes cluster nodes, here is where your services will be deployed
  - Master node(s): Your Kubernetes cluster control plane , this is where the management functions for your cluster take place
  - Agent node(s): These are worker nodes, they will be running most of the services
  - Storage node(s): These can be `master` or `agent` nodes, this only marks which nodes will have external storage attached.

## Pre-deployment

### Basic node setup

These steps need to be executed in order and before moving on with the process, since they will make it possible to run the automations.

#### Control Node

- Install [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) (this is only necessary if you want to use the playbooks)
- Install [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- Install [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

#### Managed Nodes

- Flash Debian GNU/Linux 11 (bullseye) on the nodes (depending on your node's CPU you might need to flash an `amd64`  or `arm64` image)
- Connect the node to your network (steps might vary depending on the OS)
- Set up password-less [SSH](https://www.cyberciti.biz/faq/how-to-set-up-ssh-keys-on-linux-unix/) (this step is done from your `Control node`)

  ```shell
  ssh-copy-id {your username}@<NODE_IP>
  ```
  
  - It is strongly recommended that you use the same username in your `Control node` an your `Managed nodes` [ansible playbooks](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_intro.html) will also make changes on your local filesystem and we want to avoid unnecessary privilege escalation
  
- Add your user to the `sudo` group:

  ```shell
    # as root
    usermod -aG sudo {your username}
  ```

- Allow memebers of the sudo group to run any command without a password:

  ```shell
    # as root
    visudo
  ```

  - Add the following line to the file (or edit the existing one):

    ```shell
      %sudo ALL=(ALL) NOPASSWD:ALL
    ```

  - Alternatively you can just edit /etc/sudoers

- Create your free public domain (this is necessary if you want to use valid [SSL certificates](https://www.kaspersky.com/resource-center/definitions/what-is-a-ssl-certificate)) and access some services outside of your private network, if you don't want this, you can check [this](#domain-and-public-ip)
  
  - DuckDNS (deprecated)
    - Create an account on duckdns.org
    - Create your subdomain on duckdns.org, save your subdomain and your token
  
  - DeSec
    - Create an account on [DeSec](https://desec.io/)
    - Create your domain, save your subdomain
    - Create a wildcard record pointing to your **public IP address**
      - You can get your public IP [here](https://www.whatsmyip.org/)
      - Once everything is up and running there will be a service to automatically update this value
    - Under `Token management` create your token and save it for later

- Point your public IP address to your cluster (this might not work if your public IP address is _NATed_ by your ISP, so mileage might vary)
  
  - This can be achieved by [Port Forwarding](https://nordvpn.com/blog/port-forwarding/) ports `80` and/or `443` in your edge router to your `Master node`'s IP address
  
  - If your public IP is being _NATed_ consider upgrading to a static IP address or modifying the values to deploy with self-signed certificates
  
    - A simple way to find out if this is the case is to forward a random port (let's say: `8080`) to your `Control node`
  
    - Run a simple web service on that port in your `control node`:
  
      ```shell
      python -m http.server 8080
      ```
  
    - And then, on your browser, go to `http://{your public ip}:8080`, if it errors out, and you're certain you did everything correctly, chances are your public IP is being `CG-NATed` by your ISP an you will have to take it up with them

##### Domain and public IP

The main reasons for us to get a domain name are:

- To be able to automatically generate SSL certificates for our services and get rid of the browser notification that we're using insecure certificates
- In case you want to be able to share some (or all) of your services with friends or access them when away from home without having to deal with a VPN

There are measures in place to improve security and restrict access to your services from outside your network, but it's still a security risk so use it with caution and I strongly advise to leave anything sensitive exclusively on your private network.

If you already own a domain name or want to use a different solution for your free domain, you should be able to do it without having to deviate from the steps here.

If you are planning on deploying this on an [Air gapped environment](https://en.wikipedia.org/wiki/Air_gap_(networking)), a possible solution to achieve this result could be to create your domain, generate a wildcard certificate (*.{your_domain}) and to use that certificate in your cluster for all services (this alternative won't be covered in the documentation).

### Storage

This is only necessary if you want to use longhorn. *_*I don't recommend using longhorn for single node deployments*_.

- Attach an external hard drive or create and format a partition on your `storage` node(s) and take note of that partition's name
  - As of now, the playbooks will only use the same partition name for all `storage` nodes, so bear that in mind if you want to have it all configured from the get go

If you're planning on adding any additional drives later that's totally fine, and they can be added manually from the Longhorn UI, or from ansible, only thing to keep in mind is that if you are planning on using Longhorn from the beginning, you should at least have one storage node so the correct Peristent Volume Claims get created and you won't risk loosing any data.

### VPN Setup

Some modules (`rtorrent` for now), have a Wireguard VPN addon, in order for this to work you need to pass it the Wireguard config. The wireguard config will be stored as a Kubernetes secret and mounted in the container, you need to pass the contents of the config file as a `base64` encoded string, you can get this string by running:

```bash
cat wireguard.config | base64
```

and then adding to your `terraform.tfvars`:

```hcl
# With your own encoded string, of course
vpn_config = ""
```

#### Obtaining the VPN config

Your VPN provider should have a config file available for you to use, it should be a simple Google Search away. If you don't have one already you can use [Proton VPN](https://protonvpn.com/https://protonvpn.com/) that offers a free plan and lets you easily download the Wireguard [config file](https://protonvpn.com/support/wireguard-configurations/).

If you are like me and are stuck with NordVPN for the foreseeable future, you would have realized already that there's no easy way to get the config file. That's why this repo has a `git submodule` under `scripts/NordVPN-Wireguard` that will let you generate the config file yourself. You can find the instructions on how to use it in the [README](./scripts/NordVPN-Wireguard/README.md).

## Automated Deployment

This section covers the `k3s` installation using [ansible playbooks](#ansible) and the deployment of the services using a mix of [Terraform and ArgoCD](#terraform). The playbooks are in charge of preparing the environment, installing required packages, tagging nodes and making the necessary local changes in order for terraform to work (variable creation, kubeconfig creation, etc.) unless you know what you're doing it is strongly advised to install everything using the provided playbooks.

### Ansible

If you're planning on manually installing kubernetes or if you already have a kubernetes cluster you can skip this section and go straight to [Terraform](#terraform). Just make sure that everything is matching to what `ansible` would have created (especially installing dependencies and tagging of resources)

1. Create `ansible/inventory/deploy/group_vars/all.yml` with the following:

    ```yaml
      ---
      k3s_version: v1.26.3+k3s1
      systemd_dir: /etc/systemd/system
      master_ip: "{{ hostvars[groups['master'][0]]['ansible_host'] | default(groups['master'][0]) }}"
      extra_server_args: "--disable traefik --prefer-bundled-bin --kube-controller-manager-arg bind-address=0.0.0.0 --kube-proxy-arg metrics-bind-address=0.0.0.0 --kube-scheduler-arg bind-address=0.0.0.0" 
      timezone: 'Your timezone' # in the format America/Chicago
      nfs_drive_partition: 'your previously selected partition' # for example: "sda1"
      allowed_ssh_networks:
          - network1 # in ip/subnet notation: 192.168.1.0/24
          - network2
    ```

2. Create `ansible/k3s-ansible/inventory/deploy/hosts.ini` with the following:
  
    ```ini
    [master]
    {master hostname} ansible_host= {master ip} priority=critical
    
    [agent]
    {agent hostname} ansible_host= {agent ip} priority=low
    {agent hostname2} ansible_host= {agent ip2} priority=high
    
    [k3s:children]
    master
    agent
    
    [storage:children]
    master

    ; Additionally you can add individual members to the storage group by doing:
    ;[storage]
    ;{agent hostname2}
    ```

   - You can always delete or comment (`;`) depending on your setup
   - Replace the values inside {} with your actual values
   - The priority should be one of [critical,high,low]

3. Run the ansible playbook (from the root of the repo):
  
   ```bash
   ansible-playbook ./ansible/site.yml -i ./ansible/inventory/deploy/hosts.ini --ask-become-pass --user {your_user}
   ```

4. Once the playbook finishes you can verify if everything is working by running:
  
     ```bash
     ❯ kubectl get nodes
      NAME     STATUS   ROLES                  AGE    VERSION
      kilvin   Ready    control-plane,master   131d   v1.26.3+k3s1
      kvothe   Ready    worker                 34d    v1.26.3+k3s1
     ```

5. (Optional) All of the plays have been tagged, so, if you want to make any changes and don't want to run everything again you can just run plays matching specific tags:
  
   ```bash
   ansible-playbook ./ansible/site.yml -i ./ansible/inventory/deploy/hosts.ini --ask-become-pass --user {your_user} --tags kubernetes,download

   ```

### Terraform

Ansible just installs kubernetes and makes the necessary configurations, but doesn't deploy anything to the cluster, as a matter of fact, by default the playbook even skips some components that come with `k3s` by default to allow for a fresh, fully customized deployment.

1. Create `terraform/terraform.tfvars`, you can use `terraform/terraform.tfvars.example` as a base, below is a table with an explanation for each variable:
   | Component    | Name                                     | Description                                                                                                                                                                                                              |
   | ------------ | ---------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
   | Cert Manager | letsencrypt_email                        | Email associated with Let's Encrypt certification |
   |              | letsencrypt_server                       | Let's Encrypt server URL (you should use `https://acme-staging-v02.api.letsencrypt.org/directory` initially and `https://acme-v02.api.letsencrypt.org/directory` once you verify that everything is working as intended) |
   | Traefik      | source_range                             | Comma separated list of IP source range to allow for internal traffic ("192.168.1.0/24,10.42.1.0/24") |
   |              | source_range_ext                         | Comma separated list of IPs to allow for external traffic  (95.95.95.95/32,85.85.85.85/32) |
   | Global       | timezone                                 | Timezone for the pods |
   |              | domain                                   | Domain for the infrastructure (something like {your_domain}.dedyn.io) |
   |              | master_hostname                          | Master server's hostname (this will be autogenerated from ansible in the future) |
   |              | master_ip                                | IP address of the master server (this will be autogenerated from ansible in the future) |
   | DNS          | token                                    | The token you obtained [here](#managed-nodes)  |
   | Longhorn     | nfs_server                               | NFS server address (this is  autogenerated from ansible) |
   |              | nfs_backupstore                          | NFS backup storage path (this is  autogenerated from ansible) |
   | ArgoCD       | gh_username                              | Your GitHub username, ArgoCD will use this to access your repo (could be this one or a fork) |
   |              | gh_token                                 | Your GitHub token for ArgoCD authentication |
   | Rtorrent     | vpn_config                               | Configuration for VPN with rTorrent in `base64` format, obtained [here](#vpn-setup) |
   | Plex         | allowed_networks                         | IP ranges allowed to access Plex |
   |              | plex_claim_token                         | Token to claim Plex server |
   | Keys         | api_keys.radarr_key                      | API key for Radarr |
   |              | api_keys.sonarr_key                      | API key for Sonarr |
   |              | api_keys.prowlarr_key                    | API key for Prowlarr |
   |              | api_keys.bazarr_key                      | API key for Bazarr |
   |              | api_keys.plex_key                        | API key for Plex |
   |              | api_keys.portainer_key                   | API key for Portainer |
   |              | api_keys.jellyseerr_key                  | API key for Jellyseerr |
   |              | api_keys.pihole_key                      | API key for Pi-hole |
   |              | api_keys.sabnzbd_key                     | API key for SABnzbd |
   |              | api_keys.discord_webhook_url             | Discord webhook URL for notifications |
   |              | api_keys.kwatch_discord_webhook_url      | Discord webhook URL for KWatch notifications |
   |              | api_keys.authelia_JWT_TOKEN              | JWT token for Authelia authentication |
   |              | api_keys.authelia_SESSION_ENCRYPTION_KEY | Session encryption key for Authelia |
   |              | api_keys.authelia_STORAGE_ENCRYPTION_KEY | Storage encryption key for Authelia |
   |              | api_keys.crowdsec_enrollment_key         | Enrollment key for CrowdSec |
   | Components   | use_sandbox                              | Boolean to determine if sandbox environment is created |
   |              | use_longhorn                             | Boolean to determine if Longhorn is used |


## ArgoCD

- Get admin user by running:

```shell
kubectl get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' -n gitops | base64 -d
```

```shell
- terraform taint "module.argocd_application[\"promtail\"].argocd_application.application[0]"
```

## Manual Deployment (not recommended)

Alternatively you can deploy everything manually, but you will need to do it in the following order (this is the order that the automated deployment script runs the commands, you can always check it for reference):

___This does not mean that you won't have to create the variable files, otherwise you will have to pass them as arguments to the commands___

- Execute the ansible playbook that will make sure that all requirements in the node(s) are met:

    ```shell
    ansible-playbook ./ansible/k3s-ansible/site.yml -i ./ansible/k3s-ansible/inventory/deploy/hosts.ini -u $user 
    ```

- Install the necessary CRDs for `traefik` and `cert-manager`:

    ```shell
    kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.11.0/cert-manager.crds.yaml
    kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v2.9/docs/content/reference/dynamic-configuration/kubernetes-crd-definition-v1.yml
    ```

### Ansible

- From the root folder

### Longhorn

If you are going to use longhorn verify that the below requirements are met before deploying:

- <https://staging--longhornio.netlify.app/docs/0.8.1/deploy/install/#installation-requirements>

## Troubleshooting

Read the [Troubleshooting](./docs/Troubleshooting.md) file to find solutions to common problems.

## Expanding the repo

Read the [Expanding](./docs/Expanding.md) file to find a more in-depth explanation on how things work and how to add your own services and functionalities.

## General knowledge

### Kubectl

## Uninstalling

### Uninstall Longhorn

<https://longhorn.io/docs/1.4.1/deploy/uninstall>

## Adult Content

Adult content is provided using [Whisparr](https://wiki.servarr.com/whisparr), this won't be enabled by default and not be part of the `modules_to_run` variable, if you want to be able to download adult cotent, you will have to add that manually.

## TODO
- Mylar
- kavita

- Add loki documentation
- Airlock Microgateway
- linkerd
- k8tz
- k8s-scanner
- https://artifacthub.io/packages/helm/geek-cookbook/samba
- kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v2.10/docs/content/reference/dynamic-configuration/kubernetes-crd-rbac.yml
- kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v2.10/docs/content/reference/dynamic-configuration/kubernetes-crd-definition-v1.yml
- Dex not working
- Explain plex external setup
- Explain traefik automatic ip addition to whitelist