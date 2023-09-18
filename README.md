# Pi-k8s

\*Mostly\* Automated setup to install _k3s_ and additional services on your home cluster.

## Table of Contents

- [Pi-k8s](#pi-k8s)
  - [Table of Contents](#table-of-contents)
  - [Terminology](#terminology)
  - [Pre-deployment](#pre-deployment)
    - [Basic node setup](#basic-node-setup)
      - [Control Node](#control-node)
      - [Manage Nodes](#manage-nodes)
    - [Storage](#storage)
    - [VPN Setup](#vpn-setup)
      - [Obtaining the VPN config](#obtaining-the-vpn-config)
  - [Automated Deployment](#automated-deployment)
  - [ArgoCD](#argocd)
  - [Manual Deployment (not recommended)](#manual-deployment-not-recommended)
    - [Ansible](#ansible)
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
- Storage node(s): These can be `master` or `agent` nodes, but this is where your storage will be

## Pre-deployment

### Basic node setup

These steps need to be executed in order and before moving on with the process, since they will make it possible to run the automations.

#### Control Node

- Install [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) (this is only necessary if you want to use the playbooks)
- Install [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- Install [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

#### Manage Nodes

- Flash Debian GNU/Linux 11 (bullseye) on the nodes (depending on your node's CPU you might need to flash an `amd64`  or `arm64` image)
- Connect the node to your network (steps might vary depending on the OS)
- Set up password-less [SSH](https://www.cyberciti.biz/faq/how-to-set-up-ssh-keys-on-linux-unix/) (this step is one from your `Control node`)

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

- Create your free public domain (this is necessary if you want to use valid [SSL certificates](https://www.kaspersky.com/resource-center/definitions/what-is-a-ssl-certificate))
  
  - DuckDNS (deprecated)
    - Create an account on duckdns.org

    - Create your subdomain on duckdns.org, save your subdomain and your token
  
  - DeSec
    - Create an account on https://desec.io/
    - Create your domain, save your subdomain
    - Create a wildcard record pointing to your public IP address

- Point your subdomain to your public IP address (this won't work if your public IP address is _NATed_ by your ISP)
  
  - This can be achieved by [Port Forwarding](https://nordvpn.com/blog/port-forwarding/) ports `80` and/or `443` in your edge router to your `Master node`'s IP address
  
  - If your public IP is being _NATed_ consider upgrading to a fixed IP address or modifying the values to deploy with self-signed certificates
  
    - A simple way to find out if this is the case is to forward a random port (let's say: `8080`) to your `Control node`
  
    - Find out your public IP (you can just go to [whatsmyip](https://www.whatsmyip.org/) for this)
  
    - Run a simple web service on that port in your `control node`:
  
      ```shell
      python -m http.server 8080
      ```
  
    - And then, on your browser, go to `http://{your public ip}:8080`, if it errors out, and you're certain you did everything correctly, chances are your public IP is being `CG-NATed`by your ISP an you will have to take it up with them
  
      ___Probably you can bypass this by generating your certificates separately, and then importing them, but I haven't tested this___
  
### Storage

This is only necessary if you want to use longhorn. ___I don't recommend using longhorn for single node deployments___  (at least I haven't been able to make it work properly with just one node, also I don't think it will be of more use in that particular scenario).

- Attach an external hard drive or create and format a partition on your `storage` node(s) and take note of that partition's name
  - The playbooks will only use __one__ partition name for all `storage` nodes, so bear that in mind

### VPN Setup

Some modules (`rtorrent` for now), have a Wireguard VPN addon, in order for this to work you need to pass it the Wireguard config. The wireguard config will be stored as a Kubernetes secret and mounted in the container, you need to pass the contents of the config file as a `base64` encoded string, you can get this string by running:

```bash
cat wireguard.config | base64
```

and then adding to your `terraform.tfvars`:

```hcl
# With your own encoded string, of course
vpn_config = "SSdtIHNvIGdsYWQgeW91IHRvb2sgdGhlIHRpbWUgdG8gZGVjb2RlIHRoaXMK"
```

#### Obtaining the VPN config

Your VPN provider should have a config file available for you to use, it should be a simple Google Search away. If you don't have one already you can use [Proton VPN](https://protonvpn.com/https://protonvpn.com/) that offers a free plan and lets you easily download the Wireguard [config file](https://protonvpn.com/support/wireguard-configurations/).

If you are like me and are stuck with NordVPN for the foreseeable future, you would have realized already that there's no easy way to get the config file. That's why this repo has a `submodule` under `scripts/NordVPN-Wireguard` that will let you generate the config file yourself. You can find the instructions on how to use it in the [README](./scripts/NordVPN-Wireguard/README.md).

## Automated Deployment

- Create `ansible/inventory/deploy/group_vars/all.yml` with the following:

    ```yaml
      ---
      k3s_version: v1.26.3+k3s1
      systemd_dir: /etc/systemd/system
      master_ip: "{{ hostvars[groups['master'][0]]['ansible_host'] | default(groups['master'][0]) }}"
      extra_server_args: "--disable=traefik"
      timezone: 'Your timezone'
      nfs_drive_partition: 'your previously selected partition'
      allowed_ssh_networks:
          - network1
          - network2
    ```

- Create `ansible/k3s-ansible/inventory/deploy/hosts.ini` with the following:
  
    ```ini
    [master]
    {master hostname} ansible_host= {master ip}
    
    [agent]
    {agent hostname} ansible_host= {agent ip}
    
    [k3s:children]
    master
    agent
    
    [storage:children]
    master
    ```
  
  - You can always delete or comment (`; *`) depending on your setup
  
- Create `terraform/terraform.tfvars` under the directory with the missing vars with the following:

- Run:

  ```shell
  bash deploy.sh
  ```

## ArgoCD

- Get admin user by running:

```shell
kubectl get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' -n gitops | base64 -d

```
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