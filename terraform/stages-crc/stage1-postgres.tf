module "dev_infrastructure_postgres" {
  source = "github.com/michaelsteven/garage-terraform-modules.git//self-managed/services/postgres?ref=mike-working"

  resource_group_name = "${var.resource_group_name}"
  resource_location   = "${var.vlan_region}"
  server_exists       = "${var.postgres_server_exists}"
  cluster_id          = "${module.dev_cluster.id}"
  tools_namespace     = "${module.dev_cluster_namespaces.tools_namespace_name}"
  dev_namespace       = "${module.dev_cluster_namespaces.dev_namespace_name}"
  test_namespace      = "${module.dev_cluster_namespaces.test_namespace_name}"
  staging_namespace   = "${module.dev_cluster_namespaces.staging_namespace_name}"
  cluster_type        = "${var.cluster_type}"
  #postgresql_user     = "${var.postgres_user}"
  #postgresql_password = "${var.postgres_password}"
  #postgresql_database = "${var.postgres_database}"
  #volume_capacity     = "${var.postgres_volume_capacity}"
}
