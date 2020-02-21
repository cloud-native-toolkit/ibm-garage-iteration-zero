module "dev_infrastructure_cos" {
  source = "github.com/ibm-garage-cloud/garage-terraform-modules.git//cloud-managed/services/cloud_object_storage?ref=v2.2.0"

  resource_group_name = module.dev_cluster.resource_group_name
  resource_location   = module.dev_cluster.region
  cluster_id          = module.dev_cluster.id
  namespaces          = module.dev_cluster_namespaces.other_namespaces
  namespace_count     = var.other_namespace_count
  name_prefix         = var.name_prefix
}
