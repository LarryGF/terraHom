
# terraHom

<img src="images/logo.svg" width="400" height="400">

_Mostly_ Automated setup to deploy _k3s_ and additional services on your home cluster using `homControl`.

## Table of Contents

- [terraHom](#terrahom)
  - [Table of Contents](#table-of-contents)
  - [Terminology 📖](#terminology-)
  - [Pre-deployment 🚀](#pre-deployment-)
    - [Basic node setup 🛠](#basic-node-setup-)
      - [Control Node](#control-node)
      - [Managed Nodes](#managed-nodes)
        - [Domain and public IP](#domain-and-public-ip)
    - [Storage 🛠](#storage-)
    - [VPN Setup 🛠](#vpn-setup-)
      - [Obtaining the VPN config](#obtaining-the-vpn-config)
  - [Automated Deployment 🚀](#automated-deployment-)
    - [(Non-exhaustive) Requirements](#non-exhaustive-requirements)
    - [Ansible](#ansible)
    - [Terraform](#terraform)
      - [(1) Base](#1-base)
      - [(2) Gitops](#2-gitops)
      - [(3) ArgoCD Application](#3-argocd-application)
      - [Accessing ArgoCD](#accessing-argocd)
  - [Post Install](#post-install)
  - [Troubleshooting](#troubleshooting)
  - [Expanding the repo](#expanding-the-repo)

## Terminology 📖

- **Control Node:** Your local computer. Most actions are executed from here.
- **Managed Nodes:** These are your [Kubernetes](https://kubernetes.io/) cluster nodes where services are deployed.
  - **Master node(s):** The control plane for your Kubernetes cluster. This is where the cluster's management functions take place.
  - **Agent node(s):** Worker nodes where most services run.
  - **Storage node(s):** Can be either `master` or `agent` nodes. Represents nodes with attached external storage.

## Pre-deployment 🚀

### Basic node setup 🛠

Ensure you follow these steps in sequence before proceeding further, as they are crucial for the automation to work seamlessly.

#### Control Node

- Install [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) (only required if you're planning to use the playbooks).
- Install [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli).
- Install [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/).

#### Managed Nodes

- Flash/Install [Debian GNU/Linux 11 (bullseye)](https://www.debian.org/) on the nodes (depending on your node's CPU you might need to flash an `amd64` or `arm64` image).
- Connect the node to your network.
- Set up password-less [SSH](https://www.cyberciti.biz/faq/how-to-set-up-ssh-keys-on-linux-unix/) (this step is done from your `Control node`):

  ```bash
  ssh-copy-id {your username}@<NODE_IP>
  ```

  - It is strongly recommended that you use the same username in your `Control node` and your `Managed nodes`. [Ansible playbooks](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_intro.html) will also make changes on your local filesystem, so avoid unnecessary privilege escalation.
  
- Add your user to the `sudo` group:

  ```bash
  # as root
  usermod -aG sudo {your username}
  ```

- Grant `sudoers` permission to run commands without a password:

  - Run:
  
    ```bash
    # as root
    visudo
    ```

  - Add or modify this line in the file:

    ```bash
    %sudo ALL=(ALL) NOPASSWD:ALL
    ```

  - Alternatively, you can directly edit `/etc/sudoers`.

- Ensure the `CD-ROM` entry in `/etc/apt/sources.list` is disabled to prevent system update failures.

- Create your free public domain for valid [SSL certificates](https://www.kaspersky.com/resource-center/definitions/what-is-a-ssl-certificate). If you don't want external access, check [this](#domain-and-public-ip).
  
  - DuckDNS (deprecated):
    - Register on duckdns.org.
    - Set up your subdomain and note down the subdomain and token.
  
  - DeSec:
    - Register on [DeSec](https://desec.io/).
    - Set up your domain and save your subdomain for later.
    - Create a wildcard record targeting your **public IP address** (Find it [here](https://www.whatsmyip.org/)).
    - Once set up, a service will be deployed to auto-update this IP.
    - In the webpage, go to `Token management`, create and note down your token.

- Direct your public IP to your cluster (might be limited if your ISP _NATs_ your public IP).
  
  - Achieve this by [Port Forwarding](https://nordvpn.com/blog/port-forwarding/) ports `80`/`443` on your router to your `Master node`'s IP.
  
  - If your IP is _NATed_, consider a static IP or deploy with self-signed certificates.
  
    - Test by forwarding port `8080` to your `Control node` and run:

      ```bash
      python -m http.server 8080
      ```
  
    - Access `http://{your public ip}:8080`. If there's an error and you've followed steps correctly, your IP might be `CG-NATed` by the ISP.

##### Domain and public IP

The main reasons for us to get a domain name are:

- To be able to automatically generate SSL certificates for our services and get rid of the browser notification that we're using insecure certificates
- In case you want to be able to share some (or all) of your services with friends or access them when away from home without having to deal with a VPN

There are measures in place to improve security and restrict access to your services from outside your network, but it's still a security risk so use it with caution and I strongly advise to leave anything sensitive exclusively on your private network.

If you already own a domain name or want to use a different solution for your free domain, you should be able to do it without having to deviate from the steps here.

If you are planning on deploying this on an [Air gapped environment](https://en.wikipedia.org/wiki/Air_gap_(networking)), a possible solution to achieve this result could be to create your domain, generate a wildcard certificate (*.{your_domain}) and to use that certificate in your cluster for all services (this alternative won't be covered in the documentation).

### Storage 🛠

This is only necessary if you want to use longhorn. *_*I don't recommend using longhorn for single node deployments*_.

- Attach an external hard drive or create and format a partition on your `storage` node(s) and take note of that partition's name
  - As of now, the playbooks will only use the same partition name for all `storage` nodes, so bear that in mind if you want to have it all configured from the get go

If you're planning on adding any additional drives later that's totally fine, and they can be added manually from the Longhorn UI, or from ansible, only thing to keep in mind is that if you are planning on using Longhorn from the beginning, you should at least have one storage node so the correct Peristent Volume Claims get created and you won't risk loosing any data.

### VPN Setup 🛠

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

## Automated Deployment 🚀

This section covers the `k3s` installation using [ansible playbooks](#ansible) and the deployment of the services using a mix of [Terraform and ArgoCD](#terraform). The playbooks are in charge of preparing the environment, installing required packages, tagging nodes and making the necessary local changes in order for terraform to work (variable creation, kubeconfig creation, etc.) unless you know what you're doing it is strongly advised to install everything using the provided playbooks. In case you want to skip this here is a list of some resource that could be missing, but I might have missed something:

### (Non-exhaustive) Requirements

- [Longhorn](https://staging--longhornio.netlify.app/docs/0.8.1/deploy/install/#installation-requirements)

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

2. Create `ansible/inventory/deploy/hosts.ini` with the following:
  
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

5. Verify that everything ran as expected, some of the required steps won't be executed if all roles don't finish running succesfully on all hosts

6. (Optional) All of the plays have been tagged, so, if you want to make any changes and don't want to run everything again you can just run plays matching specific tags:
  
   ```bash
   ansible-playbook ./ansible/site.yml -i ./ansible/inventory/deploy/hosts.ini --ask-become-pass --user {your_user} --tags kubernetes,download
   
   ```

### Terraform

Ansible just installs kubernetes and makes the necessary configurations, but doesn't deploy anything to the cluster, as a matter of fact, by default the playbook even skips some components that come with `k3s` by default to allow for a fresh, fully customized deployment.

1. Create `terraform/terraform.tfvars`, you can use `terraform/terraform.tfvars.example` as a base, below is a table with an explanation for each variable, you can ignore the `Rtorrent`,`Plex` and `Keys` components for now since they won't be used until the services are deployed:

2. Rename and/or edit the file `terraform/modules/base/submodules/adguard/helm/dns-rewrites.example.yaml` to `terraform/modules/base/submodules/adguard/helm/dns-rewrites.config.yaml`, this basically tells `Adguard`'s DNS to resolve some services using their private IP addresses instead of their public ones. You can add or remove entries as you please

3. (Optional) If you are feeling adventurous, in theory you could run everything now, but you might find yourself with unexpected errors or services/configs that you don't want. Maybe you want to validate if the default values are correct, in any case, you can run (from the root of the repo):

   ```bash
    # terraform -chdir=terraform init
    # terraform -chdir=terraform apply -auto-approve
   ```

4. In the sections below I will cover the different modules and their functions in order:

#### (1) Base

As its name implies, the `base` module deploys the base services needed in order for the rest of the applications to run, it also creates all the namespaces that will be used. There are many submodules, some are deprecated and not currently in use, but the code is still there in case anyone finds it helpful. The submodules deployed are:

- Cert-manager: this module deploys a ClusterIssuer that generates certificates using LetsEncrypt for all of your ingresses.
- Traefik: this module deploys a modified `traefik` LoadBalancer, replacing the `traefik` that comes with `k3s` by default. It also deploys several middlewares:
  - Error pages: this also deploys an `error pages` service that shows a custom error page and comes as a default view for any HTTP error that traefik shows
  - Ip Whitelist: this will only allow traffic from the subnets/IPs defined in `terraform.tfvars`. By default this will always fetch and add your public IP to the whitelists at run time. It also adds the IP ranges for Cloudflare servers for future Cloudflare integrations
  - Redirect https: this will redirect all `http` to `https`
- Longhorn: this modules installs and configures `longhorn`
- Prometheus-CRDS: this just installs some additional CustomResourceDefinitions that at this moment are not present in the cluster in order to create ServiceMonitors, PrometheusRules, etc
- DDclient: this module is in charge of updating your domain to always point to your public IP
- Adguard Home: this module deploys `Adguard Home` with pre-configured lists and can act as your local DNS server. Be sure to add `nameserver {master node ip}` to the `/etc/resolve.conf` in your `control node`.
- ArgoCD: this module deploys `ArgoCD` to your cluster. Once this module has been installed it will be used to deploy all of the other applications to your cluster.

Now that you know all of the components for the `base` module you can deploy it to your cluster by running from the root of the repo:

```bash
terraform -chdir=terraform init
terraform apply -chdir=terraform -auto-approve -target module.base   
```

If it complains about missing CRDs you can install them by running:

```bash
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.11.0/cert-manager.crds.yaml
kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v2.10/docs/content/reference/dynamic-configuration/kubernetes-crd-rbac.yml
kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v2.10/docs/content/reference/dynamic-configuration/kubernetes-crd-definition-v1.yml
# and then run again
terraform apply -chdir=terraform -auto-approve -target module.base   
```

#### (2) Gitops

The `Gitops` module is responsible for configuring `ArgoCD` and making it usable: it creates default repositories, repository credentials, projects and permission. It is also tasked with initializing the `ArgoCD` provider with the correct credentials removing that responsibility from the next module. You can deploy it by running:

```bash
terraform apply -chdir=terraform -auto-approve -target module.gitops   
```

#### (3) ArgoCD Application

This is where the interesting part happens, this module is responsible for deploying your applications, it achieves this by making `Terraform` and `ArgoCD` work togehter, below is a more in-depth explanation of how it works and its components:

- `applications.yaml`: this `YAML` contains the configuration for all of the applications that can be deployed, from here you can control if an application will be deployed or not, where will it be deployed (namespace and node), persistence, as well as values to be overwritten.

- For each application marked to be deployed the module creates an `Application` CRD that will get picked up and deployed by `ArgoCD` following these steps:
  - Each application is declared as an [umbrella-chart](https://helm.sh/docs/howto/charts_tips_and_tricks/#complex-charts-with-many-dependencies) inside the `argocd` folder in the root of the repo. This allows us to take advantage of this new `umbrella chart` to install any additional desired kubernetes manifests, and provide basic configuration to the chart using the `values.common.yaml`
  - Each application also has a counterpart inside `terraform/modules/argocd_application/applications`, this allows us to use terraform variables and data to further configure the `ArgoCD` application without having to explicitly declare anything extra (this is done through the `override` key for each application in `applications.yaml`)
  - If the application has volumes declared it will create any necessary PVCs with the desired configs (if Longhorn is enabled it will use the `longhorn` `StorageClass`, otherwise will use the `local-path` `StorageClass`)

- Each application in the repo should work out of the box and they come pre-configured to work fine in this particular environment, so they should work well together. Of course, they come with a highly opinionated configuration, so you're always free to make any changes.

You can read the [Applications](./docs/Applications.md) file to find out what each application does and whic ones are enabled by default.

It is worth noting that the helm charts deployed as part of the `base` module won't be visible in `ArgoCD` since they weren't created using `Applications` but directly installed using helm charts from `Terraform`. The same thing happens with the `PersistentVolumes` and `PersistentVolumeClaims`, they are not visible as a resource in `ArgoCD` since they were created from `Terraform` and are just being referenced as an existing `PVC` in the helm values file, but they will be visible from `Longhorn`'s UI.

At this point everything should be up and running, if you face any issues you can head to the [Troubleshooting section](#troubleshooting), and if that doesn't solve your problem feel free to open an issue in the repo or write an email and I will do my best to help you.

#### Accessing ArgoCD

- First thing you need to do is to get the admin user's password by running:

```shell
kubectl get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' -n gitops | base64 -d
```

- You will get a string in this form: `y3hGrasC0123LXc-%` be sure not to copy the `%` since that is not part of the password
- Once you have that you can go to `https://argo.{your_domain}/`, login as `admin` with the previously obtained password and you will be greeted by this screen:
  ![argocd screen](images/argo.png)

- Alternatively, if you are deploying the default applications, or at least the `homepage` application, you can head to `https://home.{your_domain}/` where you will find a dashboard that will automatically update with links to your deployed services:
  ![home dashboard](images/home.png)

## Post Install

Read the [Post-Install](./docs/Post-Install.md) file to see any additional configs for some of the services to be deployed

## Troubleshooting

Read the [Troubleshooting](./docs/Troubleshooting.md) file to find solutions to common problems.

## Expanding the repo

Read the [Expanding](./docs/Expanding.md) file to find a more in-depth explanation on how things work and how to add your own services and functionalities.
