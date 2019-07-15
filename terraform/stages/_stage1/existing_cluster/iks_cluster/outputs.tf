output "iks_cluster_id" {
  value       = "${data.ibm_container_cluster_config.iks_cluster.id}"
  description = "ID of the resource group that was created."
}

output "iks_cluster_region" {
  value       = "${data.ibm_container_cluster_config.iks_cluster.region}"
  description = "ID of the resource group that was created."
}

output "iks_config_file_path" {
  value       = "${data.ibm_container_cluster_config.iks_cluster.config_file_path}"
  description = "Path to the config file for the cluster."
}

output "iks_ingress_hostname" {
  value       = "${var.cluster_name}.${var.iks_cluster_region}.containers.appdomain.cloud"
  description = "Ingress hostname of the IKS cluster."
}
