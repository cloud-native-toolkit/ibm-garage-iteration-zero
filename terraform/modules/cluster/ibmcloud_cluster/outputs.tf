output "id" {
  value       = "${data.ibm_container_cluster_config.cluster.id}"
  description = "ID of the cluster."
}

output "name" {
  value       = "${local.cluster_name}"
  description = "Name of the cluster."
}

output "resource_group_name" {
  value       = "${var.resource_group_name}"
  description = "Name of the resource group containing the cluster."
}

output "region" {
  value       = "${data.ibm_container_cluster_config.cluster.region}"
  description = "Region containing the cluster."
}

output "ingress_hostname" {
  value       = "${data.local_file.ingress_subdomain.content}"
  description = "Ingress hostname of the cluster."
}

output "server_url" {
  value       = "${data.local_file.server_url.content}"
  description = "The url of the control server."
}

output "config_file_path" {
  value       = "${data.ibm_container_cluster_config.cluster.config_file_path}"
  description = "Path to the config file for the cluster."
}

output "type" {
  value       = "${data.local_file.cluster_type.content}"
  description = "The type of cluster (openshift or kubernetes)"
  depends_on  = ["null_resource.oc_login"]
}

output "login_user" {
  value       = "${var.login_user}"
  description = "The username used to log into the openshift cli"
}

output "login_password" {
  value       = "${var.ibmcloud_api_key}"
  description = "The password used to log into the openshift cli"
}

output "ibmcloud_api_key" {
  value       = "${var.ibmcloud_api_key}"
  description = "The API key for the environment"
}
