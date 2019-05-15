module "dev_iks_cluster" {
  source = "./iks_cluster"

  resource_group_name           = "${var.resource_group_name}"
  private_vlan_number           = "${var.private_vlan_number}"
  private_vlan_router_hostname  = "${var.private_vlan_router_hostname}"
  public_vlan_number            = "${var.public_vlan_number}"
  public_vlan_router_hostname   = "${var.public_vlan_router_hostname}"
  vlan_datacenter               = "${var.vlan_datacenter}"
  vlan_region                   = "${var.vlan_region}"
}

module "dev_iks_helm_install" {
  source = "./iks_helm_install"

  resource_group_name     = "${var.resource_group_name}"
  iks_cluster_id          = "${module.dev_iks_cluster.iks_cluster_id}"
  iks_cluster_region      = "${module.dev_iks_cluster.iks_cluster_region}"
  kubeconfig_download_dir = "${var.user_home_dir}"
}


module "dev_tools_ibmcloud" {
  source = "./tools_ibmcloud"

  resource_group_name = "${var.resource_group_name}"
  resource_location   = "${var.vlan_region}"
}

module "dev_tools_helm_releases" {
  source = "./tools_helm_releases"

  iks_cluster_id                                = "${module.dev_iks_cluster.iks_cluster_id}"
  iks_cluster_region                            = "${module.dev_iks_cluster.iks_cluster_region}"
  iks_ingress_hostname                          = "${module.dev_iks_cluster.iks_ingress_hostname}"
  iks_cluster_config_file                       = "${module.dev_iks_helm_install.iks_cluster_config_file}"
  tiller_namespace                              = "${module.dev_iks_helm_install.tiller_namespace}"
  tiller_service_account_name                   = "${module.dev_iks_helm_install.tiller_service_account_name}"
  sonarqube_postgresql_service_account_username = "${module.dev_tools_ibmcloud.postgresql_service_account_username}"
  sonarqube_postgresql_service_account_password = "${module.dev_tools_ibmcloud.postgresql_service_account_password}"
  sonarqube_postgresql_hostname                 = "${module.dev_tools_ibmcloud.postgresql_hostname}"
  sonarqube_postgresql_port                     = "${module.dev_tools_ibmcloud.postgresql_port}"
  sonarqube_postgresql_database_name            = "${module.dev_tools_ibmcloud.postgresql_database_name}"
}
