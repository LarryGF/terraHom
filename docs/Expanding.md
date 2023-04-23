# Extending the deployment

## Table of contents

- [Extending the deployment](#extending-the-deployment)
  - [Table of contents](#table-of-contents)
  - [Storage](#storage)
    - [Storage Module](#storage-module)
      - [Adding a new PersistentVolumeClaim](#adding-a-new-persistentvolumeclaim)

## Storage

### Storage Module

It looks a little messy, but the `storage` module is designed to be as modular as possible. The idea is for you to be able to create all the required storage resources for your deployment in a single definition and aims to do all the configuration bits as automatically as possible, inferring most of the parameters from the variables you provide.

#### Adding a new PersistentVolumeClaim
