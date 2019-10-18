# The type of cluster that will be created/used (kubernetes or openshift)
cluster_type="kubernetes"
# Flag indicating if we are using an existing cluster or creating a new one
cluster_exists="false"

# The cluster name can be provided (particularly if using existing cluster) or it will
# default to '${resource_group_name}-cluster'
#cluster_name="<cluster name>"

# Vlan config
resource_group_name="<resource group>"
vlan_region="us-east"

# The following values tell the IBMCloud terraform provider the details about the new
# cluster it will create.
# If `cluster_exists` is set to `true` then these values will not be used (although the
# variable must still be defined)
vlan_datacenter="wdc04"
private_vlan_id="2440701"
public_vlan_id="2440699"

# Flag indicating if we are using an existing postgres server or creating a new one
postgres_server_exists="false"
