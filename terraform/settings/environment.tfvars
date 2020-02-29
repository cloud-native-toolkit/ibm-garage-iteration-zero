# The type of cluster that will be created/used (kubernetes or openshift)
cluster_type="ocp4"
# Flag indicating if we are using an existing cluster or creating a new one
cluster_exists="true"

# The prefix that should be applied to the cluster name and service names (if not provided
# explicitly). If not provided then the resource_group_name will be used as the prefix.
name_prefix="gsi-dev-ocp43"

# The cluster name can be provided (particularly if using an existing cluster). The value
# for cluster name used by the scripts will be set in the following order of presidence:
# - "${cluster_name}"
# - "${name_prefix}-cluster"
# - "${resource_group_name}-cluster"
cluster_name="gsi-dev-ocp43-cluster"

resource_group_name="gsi-developer-team"
vlan_region="us-south"

# Flag indicating if we are using an existing postgres server or creating a new one
postgres_server_exists="false"
