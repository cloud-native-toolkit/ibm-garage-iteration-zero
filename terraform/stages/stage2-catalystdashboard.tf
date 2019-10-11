module "dev_tools_catalystdashboard_release" {
  source = "github.com/ibm-garage-cloud/garage-terraform-modules.git//tools/catalystdashboard_release?ref=v1.0.21"


  cluster_ingress_hostname = "${module.dev_cluster.ingress_hostname}"
  cluster_config_file      = "${module.dev_cluster.config_file_path}"
  cluster_type             = "${var.cluster_type}"
  releases_namespace       = "${module.dev_cluster_namespaces.tools_namespace_name}"
  tool_config_maps         = [
    "${module.dev_tools_argocd_release.config_name}",
    "${module.dev_tools_artifactory_release.config_name}",
    "${module.dev_tools_jenkins_release.config_name}",
    "${module.dev_tools_pactbroker_release.config_name}",
    "${module.dev_tools_sonarqube_release.config_name}"
  ]
  tls_secret_name          = "${module.dev_cluster.tls_secret_name}"
}
