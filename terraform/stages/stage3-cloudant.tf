module "dev_infrastructure_cloudant" {
  source = "github.com/ibm-garage-cloud/garage-terraform-modules.git//cloud-managed/services/cloudant?ref=v2.3.3"

  resource_group_name = module.dev_cluster.resource_group_name
  resource_location   = module.dev_cluster.region
  cluster_id          = module.dev_cluster.id
  namespaces          = module.dev_cluster_namespaces.release_namespaces
  namespace_count     = var.release_namespace_count
  name_prefix         = var.name_prefix
}
