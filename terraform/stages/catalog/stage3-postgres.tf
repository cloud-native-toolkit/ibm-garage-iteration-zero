module "dev_infrastructure_postgres" {
  source = "github.com/ibm-garage-cloud/garage-terraform-modules.git//cloud-managed/services/postgres?ref=v2.2.4"

  resource_group_name = var.resource_group_name
  resource_location   = var.vlan_region
  server_exists       = var.postgres_server_exists
  cluster_id          = module.dev_cluster.id
  namespaces          = concat([module.dev_cluster_namespaces.tools_namespace_name], module.dev_cluster_namespaces.release_namespaces)
  namespace_count     = var.release_namespace_count+1
  name_prefix         = var.name_prefix
  tags                = [module.dev_cluster.tag]
}
