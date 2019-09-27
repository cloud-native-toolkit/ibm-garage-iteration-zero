module "dev_tools_catalystdashboard_release" {
  source = "github.com/ibm-garage-cloud/garage-terraform-modules.git//tools/catalystdashboard_release?ref=v1.0.0"

  cluster_ingress_hostname = "${module.dev_cluster.ingress_hostname}"
  cluster_config_file      = "${module.dev_cluster.config_file_path}"
  cluster_type             = "${var.cluster_type}"
  releases_namespace       = "${module.dev_cluster_namespaces.tools_namespace_name}"
  jenkins_secret_name      = "${module.dev_tools_jenkins_release.secret_name}"
  sonarqube_secret_name    = "${module.dev_tools_sonarqube_release.secret_name}"
  pactbroker_secret_name   = "${module.dev_tools_pactbroker_release.secret_name}"
}
