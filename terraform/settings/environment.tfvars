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

resource_group_name="<resource group>"
vlan_region="us-east"

# This flag is used to indicate that the LogDNA instance already exists. The default is "false"
# if this value is not provided. If LogDNA is not installed this value is ignored
#logdna_exists="false"
# The name of the LogDNA instance. This is particularly useful when the LogDNA instance already
# exists. If not provided the name will be derived from the name_prefix/resource_group_name
#logdna_name=""

# This flag is used to indicate that the SysDig instance already exists. The default is "false"
# if this value is not provided. If SysDig is not installed this value is ignored
#sysdig_exists="false"
# The name of the Sysdig instance. This is particularly useful when the Sysdig instance already
# exists. If not provided the name will be derived from the name_prefix/resource_group_name
#sysdig_name=""