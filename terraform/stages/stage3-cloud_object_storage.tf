module "dev_infrastructure_cos" {
  source = "github.com/ibm-garage-cloud/garage-terraform-modules.git//cloud-managed/services/cloud_object_storage?ref=v2.0.7"

  resource_group_name = "${module.dev_cluster.resource_group_name}"
  resource_location   = "${module.dev_cluster.region}"
  cluster_id          = "${module.dev_cluster.id}"
  dev_namespace       = "${module.dev_cluster_namespaces.dev_namespace_name}"
  test_namespace      = "${module.dev_cluster_namespaces.test_namespace_name}"
  staging_namespace   = "${module.dev_cluster_namespaces.staging_namespace_name}"
  name_prefix         = "${var.name_prefix}"
}
