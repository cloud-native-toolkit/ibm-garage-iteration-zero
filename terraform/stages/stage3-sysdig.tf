module "dev_infrastructure_sysdig" {
  source = "../modules/infrastructure/sysdig"

  resource_group_name = "${module.dev_cluster.resource_group_name}"
  resource_location   = "${module.dev_cluster.region}"
  cluster_id          = "${module.dev_cluster.id}"
  dev_namespace       = "${module.dev_cluster_namespaces.dev_namespace_name}"
  staging_namespace   = "${module.dev_cluster_namespaces.staging_namespace_name}"
}
