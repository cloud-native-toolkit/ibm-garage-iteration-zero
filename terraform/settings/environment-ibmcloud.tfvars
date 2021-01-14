# The type of cluster that will be created/used (kubernetes, openshift, ocp4, or crc) Use "openshift" for OpenShift 3.11
cluster_type="kubernetes"
# Flag indicating if we are using an existing cluster or creating a new one
cluster_exists="false"

# This flag is used to indicate that the cluster uses VPC infrastructure. The default is "false"
# if this value is not provided. Currently, this flag can only be used for an existing cluster
# (i.e. the script will not provision a new VPC cluster). If the cluster is a VPC cluster and
# this flag is set to "false" then the setup will fail.
vpc_cluster="false"

# The prefix that should be applied to the cluster name and service names (if not provided
# explicitly). If not provided then the resource_group_name will be used as the prefix.
#name_prefix="<name prefix for cluster and services>"

# The cluster name can be provided (particularly if using an existing cluster). The value
# for cluster name used by the scripts will be set in the following order of presidence:
# - "${cluster_name}"
# - "${name_prefix}-cluster"
# - "${resource_group_name}-cluster"
cluster_name="<cluster name>"

# The namespace that will be created and used within the IBM Container Registry to store container
# images. This value is optional and will default to the resource_group_name if not provided.
# Note: Namespaces within the IBM Container Registry are scoped to the region (e.g. us-south) and not
# to the particular account. If a registry namespace is already owned by a different account, the
# terraform process will fail while trying to provision a new namespace. At that point, the
# registry_namespace value should be updated to a unique value.
#registry_namespace="<registry namespace>"

resource_group_name="<resource group>"
region="us-east"
# If provisioning a vpc cluster, list the zone name(s) where the worker nodes should be provisioned. Each value
# should be separated by a comma. The zone names are based on the region names, so to provision the cluster in
# two zones in us-east you would set the value to "us-east-1,us-east-2". To provision in a single zone in us-south
# you would set the value to "us-south-1"
vpc_zone_count="0"

# This flag is used to indicate that a LogDNA instance should be provisioned. The default is "true"
# if this value is not provided.
#provision_logdna="true"
# The name of the LogDNA instance. If you are provisioning LogDNA this value is optional and the
# prefix_name/resource_group_name will be used for the LogDNA instance if not provided. However, if
# you are not provisioning the LogDNA instance and would like to bind the cluster to an existing instance
# then this value is REQUIRED
#logdna_name=""
# The region where the LogDNA instance has been/will be provisioned. If the value is not provided then the value
# will default to the `region`
#logdna_region=""

# This flag is used to indicate that a Sysdig instance should be provisioned. The default is "true"
# if this value is not provided.
#provision_sysdig="true"
# The name of the Sysdig instance. If you are provisioning Sysdig this value is optional and the
# prefix_name/resource_group_name will be used for the Sysdig instance if not provided. However, if
# you are not provisioning the Sysdig instance and would like to bind the cluster to an existing instance
# then this value is REQUIRED
#sysdig_name=""
# The region where the Sysdig instance has been/will be provisioned. If the value is not provided then the value
# will default to the `region`
#sysdig_region=""

# This flag is used to indicate that a Object Storage instance should be provisioned. The default is "false"
# if this value is not provided.
#cluster_provision_cos="false"
# The name of the Object Storage instance. If you are provisioning Object Storage this value is optional and the
# prefix_name/resource_group_name will be used for the Object Storage instance if not provided. However, if
# you are not provisioning the Object Storage instance and would like to bind the cluster to an existing instance
# then this value is REQUIRED
#cos_name=""

# The type of container registry that should be configured for the cluster.
# Valid options are icr, ocp, other, or none. The default value is icr
#registry_type="icr"

# The namespace in the image registry where images will be stored. If the registry_type is
# set to "icr" and the namespace is not provided then the value will default to the resource
# group name
#registry_namespace=""

# The host name of the image registry (e.g. us.icr.io or quay.io). This value is only used
# if the registry_type is set to "other".
#registry_host=""

# The username needed to access the image registry. This value is only used if the registry_type
# is set to "other"
#registry_user=""

# The password needed to access the image registry. This value is required if the registry_type is
# set to "other". If the registry_type is set to "icr" this value should be an API KEY that will be
# used to access the registry and if not provided will default to the ibmcloud_api_key used
# during the toolkit installation
#registry_password=""

# The type of source control system (github, gitlab, bitbucket, etc)
#source_control_type="github"

# The url to the source control system
#source_control_url="https://github.com"
