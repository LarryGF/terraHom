# Pi-k8s

\*Mostly\* Automated setup to install _k3s_ and additional services on your home cluster.

## Terminology

- Control Node: This is your local computer, you will be running most of the actions from here
- Managed Nodes: These will be your Kubernetes cluster nodes, here is where your services will be deployed
- Master node(s): Your Kubernetes cluster control plane , this is where the management functions for your cluster take place
- Agent node(s): These are worker nodes, they will be running most of the services
- Storage node(s): These can be `master` or `agent` nodes, but this is where your storage will be

## Pre-deployment

### Basic node setup

These steps need to be executed in order and before moving on with the process, since they will make it possible to run the automations.

### Nodes

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

  - Create an account on duckdns.org

  - Create your subdomain on duckdns.org, save your subdomain and your token

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

## Automated Deployment

- Create `ansible/inventory/deploy/group_vars/all.yml` with the following:

    ```yaml
      ---
      k3s_version: v1.26.3+k3s1
      systemd_dir: /etc/systemd/system
      master_ip: "{{ hostvars[groups['master'][0]]['ansible_host'] | default(groups['master'][0]) }}"
      extra_server_args: "--disable=traefik"
      extra_agent_args: ""
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

This mostly occurs with `helm_releases` and in this particular scenario it can be one of two problems:

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

### Resource stuck on Terminating

kubectl get namespace public-services -o json | jq '.metadata.finalizers'
kubectl patch namespace public-services -p '{"metadata":{"finalizers": []}}' --type=merge

### General Terraform errors

If you're getting terraform errors you might want to set the `TF_LOG` variable to increase the verbosity of the output. You can do this by running:

```shell
  export TF_LOG=DEBUG
```

after that you can remove it by running:

```shell
  unset TF_LOG
```

### Mark as tainted

terraform taint 'module.storage.kubernetes_persistent_volume_claim.pvcs["home-assistant"]'

### exec /sbin/tini: exec format error

This probably means that the image you're trying to run is not compatible with the architecture of the node. There can be a variety of factors, but if you have a multi-architecture cluster this is the most likely scenario. In order to fix this you can try some of these steps:

- Verify if the image supports multiple architectures
- If the image does not support multiple architectures, you can always force the deployment to run in a node with the desire architecture::
  
```helm
  nodeSelector:
  kubernetes.io/arch : {arm64 or amd64 depending on your needs}
```

- Annother possible scenario is that the image does support multiple architectures, but you redeployed and the cluster decided it needed to run in a different node, and that node doesn't support the architecture of the previous node's image. In this case you can temporarily modify  the `*-values.yaml` to force the image to be pulled again:

```helm
  image:
    tag: latest
    pullPolicy: Always
```

## General knowledge

### Kubectl

## Extending the deployment

### Storage Module

It looks a little messy, but the `storage` module is designed to be as modular as possible. The idea is for you to be able to create all the required storage resources for your deployment in a single definition and aims to do all the configuration bits as automatically as possible, inferring most of the parameters from the variables you provide.

#### Adding a new PersistentVolumeClaim

## Uninstalling

### Uninstall Longhorn

<https://longhorn.io/docs/1.4.1/deploy/uninstall>

## TODO
