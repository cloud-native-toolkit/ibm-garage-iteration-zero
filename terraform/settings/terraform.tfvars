# Flag indicating if we are using an existing cluster or creating a new one
cluster_exists="false"
# The type of cluster that will be created/used (kubernetes or openshift)
cluster_type="kubernetes"
# Flag indicating if we are using an existing postgres server or creating a new one
postgres_server_exists="false"

# Vlan config
private_vlan_number="2372"
private_vlan_router_hostname="bcr01a.dal10"
public_vlan_number="1849"
public_vlan_router_hostname="fcr01a.dal10"
vlan_datacenter="dal10"
vlan_region="us-south"
resource_group_name="<resource group>"
# The cluster name can be provided (particularly if using existing cluster) or it will
# default to '${resource_group_name}-cluster'
#cluster_name="<cluster name>"
