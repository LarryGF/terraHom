# Pi-k8s

Automated setup to install _k3s_ and some services on your Raspberry Pi

## Pre-deployment

### Basic Raspberry Pi setup

- Flash Debian GNU/Linux 11 (bullseye) arm64 to the Raspberry Pi
- Connect the Raspberry Pi to your network
- Setup passwordless SSH access to the Pi (you will need an SSH keypair for this).

    ```shell
    ssh-copy-id pi@<NODE_IP>
    ```

### Domain setup

- Create an account on duckdns.org
- Create your subdomain on duckdns.org, save your subdomain and your token
- Point your subdomain to your external IP address (this won't work if your public IP address is NATed by your ISP)
  - If your public IP is being NATed consider upgrading to a fixed IP address or modifying the values to deploy with celf signed certificates

### Storage

This is only necessary if you want to use longhorn, mount the partitions that you want longhorn to use. Longhorn by default will look for a disk mounted under `/mnt/disk01`. ___I don't recommend using longhorn for single node___ , at least I haven't been able to make it work properly with just one node (also I don't think it will be of more use in that particular scenario).
  
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
      kvothe ansible_host=ip1

      [agent]
      sim ansible_host=ip2

      [k3s:children]
      master
      agent
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
      modules_to_run = [
        "adguard",
        "bazarr",
        "cert-manager",
        "duckdns",
        "heimdall",
        "jackett",
        "radarr",
        "rancher",
        "sonarr",
        "storage",
        "traefik",
        "home-assistant",
        "longhorn"
        ]
  ```

- Run:

    ```shell
    bash deploy.sh
    ```

## Manual Deployment (not recommended)

Alternatively you can deploy everything manually, but you will need to do it in the following order (this is the order that the automated deployment script runs the commands, you can always check it for reference):

___This does not mean that you won't have to create the variable files, otherwise you will have to pass them as arguments to the commands___

- Execute the ansible playbook that will make sure that all requirements in the node(s) are met:

    ```shell
    ansible-playbook ./ansible/k3s-ansible/site.yml -i ./ansible/k3s-ansible/inventory/deploy/hosts.ini -u $user 
    ```

### Ansible

- From the root folder

## Terraform State Backups

There's a resource that every time you run `terraform apply` it will create a backup of the state file in the `./terraform/.backup` folder. It will be stored in the format `YYYY.MM.DD.HH.MM.terraform.tfstate.backup`. In case you run into any errors you can restore the state file from the backup by just copying it to the `./terraform` folder and renaming it to `terraform.tfstate`.

## Troubleshooting

### Terraform failed to create the resources during automated install

It's most likely that you have missing or wrong variables. Look at the output of the command, maybe you missed a module 😉.
If you're sure that you have all the correct variables, try to run the command again, it might be a temporary issue, this is still a work in progress and there might be race conditions that I haven't found yet.

### Temporary failure in name resolution

Check the `/etc/resolv.conf` file in the hosts, it should have the following:

  ```shell
    nameserver 1.1.1.1
  ```

### Resources taking too long to destroy

If you're destroying the resources and it's taking too long, it's most likely that you have a resource that is not being destroyed properly because it depends on another resource. If `Rancher` was installed successfully you can go to your Rancher url and delete the resources from there (bear in mind that if not done after that terraform has marked them for termination it might produce inconsistencies in the state file). It's usually safe to destroy pods because all of them are either part of a `DaemonSet` or `Deployment` and they will be recreated automatically and terraform will be able to update the state to match

## Extending the deployment

### Storage

It looks a little messy, but the `storage` module is designed to be as modular as possible, it relies on two pieces of information:

