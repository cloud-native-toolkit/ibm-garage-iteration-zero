# Flag indicating if we are using an existing cluster or creating a new one
cluster_exists="true"
# The type of cluster that will be created/used (kubernetes or openshift)
cluster_type="openshift"
# Flag indicating if we are using an existing postgres server or creating a new one
postgres_server_exists="false"

# Vlan config
vlan_datacenter="wdc04"
private_vlan_id="2440701"
public_vlan_id="2440699"
vlan_region="us-east"
resource_group_name="sms-test-oc"
cluster_name="sms-test-oc-cluster2"
# The cluster name can be provided (particularly if using existing cluster) or it will
# default to '${resource_group_name}-cluster'
#cluster_name="<cluster name>"
