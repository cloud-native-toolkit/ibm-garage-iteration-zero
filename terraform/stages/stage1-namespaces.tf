module "dev_cluster_namespaces" {
  source = "github.com/ibm-garage-cloud/garage-terraform-modules.git//generic/cluster/namespaces?ref=v2.1.7"

  cluster_type             = "${module.dev_cluster.type}"
  cluster_config_file_path = "${module.dev_cluster.config_file_path}"
  tls_secret_name          = "${module.dev_cluster.tls_secret_name}"
  tools_namespace          = "${var.tools_namespace}"
  dev_namespace            = "${var.dev_namespace}"
  test_namespace           = "${var.test_namespace}"
  staging_namespace        = "${var.staging_namespace}"
}
