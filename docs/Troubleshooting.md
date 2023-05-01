# Troubleshooting

## Table of contents

- [Troubleshooting](#troubleshooting)
  - [Table of contents](#table-of-contents)
  - [General](#general)
    - [Temporary failure in name resolution](#temporary-failure-in-name-resolution)
  - [Terraform](#terraform)
    - [Terraform failed to create the resources during automated install](#terraform-failed-to-create-the-resources-during-automated-install)
    - [General Terraform errors](#general-terraform-errors)
    - [Mark as tainted](#mark-as-tainted)
  - [Kubernetes/Helm](#kuberneteshelm)
    - [Labels](#labels)
    - [Cannot re-use a name that is still in use](#cannot-re-use-a-name-that-is-still-in-use)
    - [Resources taking too long to destroy](#resources-taking-too-long-to-destroy)
    - [Resource stuck on Terminating](#resource-stuck-on-terminating)
    - [exec /sbin/tini: exec format error](#exec-sbintini-exec-format-error)
    - [Delete/get resources from only a specific node](#deleteget-resources-from-only-a-specific-node)
  - [Longhorn](#longhorn)
    - [Node down because of Disk pressure](#node-down-because-of-disk-pressure)
    - [Unable to attach or mount volumes timed out waiting for the condition](#unable-to-attach-or-mount-volumes-timed-out-waiting-for-the-condition)
  - [Services](#services)
    - [Plex not authorized user](#plex-not-authorized-user)
  - [Restoring duplicati](#restoring-duplicati)

## General

### Temporary failure in name resolution

Check the `/etc/resolv.conf` file in the hosts, it should have the following:

  ```shell
    nameserver 1.1.1.1
  ```

## Terraform

### Terraform failed to create the resources during automated install

It's most likely that you have missing or wrong variables. Look at the output of the command, maybe you missed a module 😉.
If you're sure that you have all the correct variables, try to run the command again, it might be a temporary issue, this is still a work in progress and there might be race conditions that I haven't found yet.

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

## Kubernetes/Helm

### Labels

While ading/removing labels or annnotations (this includes `nodeSelector`) you might want to keep in mind that, even if you delete something there, as long as you're ot replacing it, Terraform might not pick up the change and just add both of them together, for example:

```yaml
# let's say you originally have this
nodeSelector:
  kubernetes.io/hostname: my_hostname

# you run it, and it works fine, but then you want to change it to something else, so you do this:
nodeSelector:
  # kubernetes.io/hostname: my_hostname
  kubernetes.io/arch: amd64
```

That last value will cause the deployment to fail, because Terraform won't recognize the previous selector as `deleted`,  it's just a change in the `values.yaml` to it, an `helm` won't remember it was there to begin with, so it won't delete it either. To fix this you can just delete the deployment and helm secret and run it again

### Cannot re-use a name that is still in use

This might happen when a `terraform apply` gets cancelled mid-deployment, and the state didn't register the resources as destroyed. Usually this means that your kubernetes deployment/daemonset/pvc etc is still there, and either it was created succesfully, or is stuck in an error.

This mostly occurs with `helm_releases` and to fix this you have to:

1. The state didn't register the resource and you have pods/services running: If you have Rancher running you can go to your dashboard and delete all resources associated with that deployment, or, if for some reason, Rancher is down, you can delete those resources using [kubectl](#kubectl), probably it will work just by deleting the `Deployment`.

2. The terraform `Helm` provider saves the releases by default on a Kubernetes secret on the format `sh.helm.release.v1.<release_name>.v<release_version>`, and sometimes Terraform fails to delete that secret (when forcefully cancelling the deployment, basically) and therefore thinks resources are there even when nothing is present; so, if you know the release name and version you can delete it using [kubectl](#kubectl) or from Rancher.

### Resources taking too long to destroy

___It is advised that you don't cancel the terraform deployment mid execution, this will prevent most of the really nasty errors___
If you're destroying the resources and it's taking too long, it's most likely that you have a resource that is not being destroyed properly because it depends on another resource. If `Rancher` was installed successfully you can go to your Rancher url and delete the resources from there (bear in mind that if not done after that terraform has marked them for termination it might produce inconsistencies in the state file). It's usually safe to destroy pods because all of them are either part of a `DaemonSet` or `Deployment` and they will be recreated automatically and terraform will be able to update the state to match.

As long as you didn't cancel the terraform deployment mid execution, there is still the chance to fix the error by  destroying it. Let's assume you were deploying a module that depended on a PersistentVolumeClaim, since all the PVCs are created by the `storage` module, if you want to do this manually you can do the following:

```shell
  terraform destroy -target module.storage -auto-approve
```

But, it would be recommended if you left the provisioning to the modules themselves, so, if you want to remove something, just remove the service name from the `modules_to_run` variable and run `terraform apply` again. This will set the desired count of the associated resources (the modules themselves as well as the storage associated) to 0, and terraform will destroy them.s

Another possibility, in the particular case of PVCs , is that `loghorn` is trying to delete a vvolume that's being used by a pod or a set of pods, in this case, the safest option is just to scale down the Kubernetes deployment, if it's just a pod you can do that manually by running:

```shell
  kubectl scale deployment -n {namespace} {deployment} --replicas=0
```

In case that it's being used by multiple pods, you can use the `scale_down` script in the `scripts` folder like this:

```shell
  ./scripts/scale_down.sh "-n {namespace}" {desired number of replicas}
```

so, for instance, let's say you want to recreate the `media` pvc, but it's being used by several pods, you would do:

  ```shell
    ./scripts/scale_down.sh "-n services" 0
    # Wait for the serices to be scaled down and the deployment to be updated
    ./scripts/scale_down.sh "-n services" 1
    # Restore the deployment to the desired number of replicas

  ```

### Resource stuck on Terminating

kubectl get namespace services -o json | jq '.metadata.finalizers'
kubectl patch namespace services -p '{"metadata":{"finalizers": []}}' --type=merge

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

### Delete/get resources from only a specific node

```shell
  kubectl get pods -o wide --all-namespaces --field-selector spec.nodeName={node_name}
  kubectl delete pods --all-namespaces --field-selector spec.nodeName={node_name}
```

## Longhorn

### Node down because of Disk pressure

This is likely to happen when one of your volumes is full beyond a certain threshold, `kubelet` will start rescheduling pods around and will, most likely, cause a bunch of pods to be stuck on `Termiating`, `Error` or `Init` depending on when you find out about this. If this happens:

- Follow the steps [here](https://longhorn.io/docs/1.4.1/advanced-resources/data-recovery/export-from-replica/) to make available the block device in the node
- Mount it as `rw` on a local folder
- Delete enough files so that the space is below the tresshold
- Restart the node

### Unable to attach or mount volumes timed out waiting for the condition

Longhorn has an option to `salvage` a volume, if the volume appears as `Faulted`, in the Longhorn UI, you can select the options, then click on `salvage` and it might solve the issue. If it doesn't, you can try the following:

If that didn't work, it is probably the fault of your `iscid` service, you can check the status of the service by running:

```shell
  systemctl status iscsid
```

worst case scenario reload it in each node:

```shell
  systemctl restart iscsid
```

## Services

### Plex not authorized user

If you receive an error: `Not authorized You do not have access to this server` this means that you have to claim the server because Plex recognizes you as an external user (your source IP is in a different range than the Plex server), in order to solve this you can:

- Pass your local subnet IP range in the form: `192.0.0.0/255.255.255.0,192.0.1.0/255.255.255.0` to the `allowed_networks` variable in `terraform.tfvars`
- Claim the server manually by going to the Plex server url and logging in with your Plex account, youhave to do this from the same network as the Plex server, in order to do that you can do a port-forwarding to the Plex server pod:

```shell
  kubectl port-forward -n services {your plex pod name} {your local port}:32400
```

and then visiting httt://localhost:{your local port} in your browser.

## Restoring duplicati 