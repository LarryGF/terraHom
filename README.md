# Pi-k8s

\*Mostly\* Automated setup to install _k3s_ and some services on your Raspberry Pi.

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

This is only necessary if you want to use longhorn, mount the partitions that you want longhorn to use. Longhorn by default will look for a disk mounted under `/mnt/disk01`. ___I don't recommend using longhorn for single node deployments___  (at least I haven't been able to make it work properly with just one node, also I don't think it will be of more use in that particular scenario).
  
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

- Install the necessary CRDs for `traefik` and `cert-manager`:

    ```shell
    kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.11.0/cert-manager.crds.yaml
    kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v2.9/docs/content/reference/dynamic-configuration/kubernetes-crd-definition-v1.yml
    ```


### Ansible

- From the root folder

### Longhorn

If you are going to use longhorn verify that the below requirements are met before deploying:

- https://staging--longhornio.netlify.app/docs/0.8.1/deploy/install/#installation-requirements

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

### Cannot re-use a name that is still in use

This might happen when a `terraform apply` gets cancelled mid-deployment, and the state didn't register the resources as destroyed. Usually this means that your kubernetes deployment/daemonset/pvc etc is still there, and either it was created succesfully, or is stuck in an error.

This mostly occurs with `helm_relesases` and in this particular scenario it can be one of two problems:

1. The state didn't register the resource and you have pods/services running: If you have Rancher running you can go to your dashboard and delete all resources associated with that deployment, or, if for some reason, Rancher is down, you can delete those resources using [kubectl](#kubectl).

2. The terraform `Helm` provider saves the releases by default on a Kubernetes secret on the format `sh.helm.release.v1.<release_name>.v<release_version>`, and sometimes Terraform fails to delete that secret (when forcefully cancelling the deployment, basically) and therefore thinks resources are there even when nothing is present; so, if you know the release name and version you can delete it using [kubectl](#kubectl) or from Rancher.

### Resources taking too long to destroy

___It is advised that you don't cancel the terraform deployment mid execution, this will prevent most of the really nasty errors___
If you're destroying the resources and it's taking too long, it's most likely that you have a resource that is not being destroyed properly because it depends on another resource. If `Rancher` was installed successfully you can go to your Rancher url and delete the resources from there (bear in mind that if not done after that terraform has marked them for termination it might produce inconsistencies in the state file). It's usually safe to destroy pods because all of them are either part of a `DaemonSet` or `Deployment` and they will be recreated automatically and terraform will be able to update the state to match.

As long as you didn't cancel the terraform deployment mid execution, there is still the chance to fix the error by  destroying it. Let's assume you were deploying a module that depended on a PersistentVolumeClaim, since all the PVCs are created by the `storage` module, if you want to do this manually you can do the following:

```shell
  terraform destroy -target module.storage -auto-approve
```

But, it would be recommended if you left the provisioning to the modules themselves, so, if you want to remove something, just remove the service name from the `modules_to_run` variable and run `terraform apply` again. This will set the desired count of the associated resources (the modules themselves as well as the storage associated) to 0, and terraform will destroy them.s

### General Terraform errors

If you're getting terraform errors you might want to set the `TF_LOG` variable to increase the verbosity of the output. You can do this by running:

```shell
  export TF_LOG=DEBUG
```

after that you can remove it by running:

```shell
  unset TF_LOG
```

## General knowledge

### Kubectl

## Extending the deployment

### Storage Module

It looks a little messy, but the `storage` module is designed to be as modular as possible. The idea is for you to be able to create all the required storage resources for your deployment in a single definition and aims to do all the configuration bits as automatically as possible, inferring most of the parameters from the variables you provide.

#### Adding a new PersistentVolumeClaim



## TODO

- Detect if longhorn is being used to set `depends_on` for the modules that require pvcs