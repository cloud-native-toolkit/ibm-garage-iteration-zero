module "dev_tools_prometheus_grafana_release" {
  source = "github.com/ibm-garage-cloud/garage-terraform-modules.git//generic/tools/prometheusgrafana_release?ref=prometheus-grafana"

  cluster_config_file_path   = module.dev_cluster.config_file_path
  monitoring_tools_namespace = module.dev_sre_namespace.tools_namespace_name
}



