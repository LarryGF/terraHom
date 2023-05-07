# Important

This branch is frozen, the purpose of this is to save a snapshot of what used to be in the repository, this is a fully functional project that is using a mix of `Terraform`, `Ansible` and `ArgoCD` for applications. Nevertheless, before following this path, applications were deployed using pure `Terraform`, which is not very much `GitOps'y`. As apps were being mmigrated to `ArgoCD` I kept the original `terraform modules`, which basically consist on the terraform resources to deploy an application (and, in some cases, some `locals` to automate things a little bit more), as well as the corresponding helm `values.yaml`.You can find this modules inside the `deprecated` folder.