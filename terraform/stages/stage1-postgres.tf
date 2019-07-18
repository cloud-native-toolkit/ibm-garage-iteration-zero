module "dev_infrastructure_postgres" {
  source = "../modules/infrastructure/postgres"

  resource_group_name      = "${var.resource_group_name}"
  resource_location        = "${var.vlan_region}"
  server_exists            = "${var.postgres_server_exists}"
}
