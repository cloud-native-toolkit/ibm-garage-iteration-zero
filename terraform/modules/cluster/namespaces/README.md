# Create Namespaces Module

Creates `tools`, `dev`, `test`, and `prod` namespaces in the
cluster provided. The namespaces and their contents will be
destroyed first before creating the new namespaces. For 
IKS clusters, the pull secrets and TLS secrets will also be
created and copied into each of these new namespaces.

## Pre-requisites

This module has the following requirements:

- `kubectl`, if creating an iks cluster
- Openshift cli (`oc`), if creating an openshift cluster
- linux shell environment
