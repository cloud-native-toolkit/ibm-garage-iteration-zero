module "dev_infrastructure_postgres" {
  source = "github.com/cloud-native-toolkit/garage-terraform-modules.git//cloud-managed/services/postgres?ref=v2.2.4"

  resource_group_name = var.resource_group_name
  resource_location   = var.region
  server_exists       = var.postgres_server_exists
  cluster_id          = module.dev_cluster.id
  namespaces          = [module.dev_tools_namespace.name]
  namespace_count     = 1
  name_prefix         = var.name_prefix
  tags                = [module.dev_cluster.tag]
}
