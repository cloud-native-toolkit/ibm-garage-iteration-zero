output "iks_cluster_id" {
  value       = "${ibm_container_cluster.iks_cluster.id}"
  description = "ID of the resource group that was created."
  depends_on  = ["ibm_container_cluster.iks_cluster"]
}

output "iks_cluster_region" {
  value       = "${ibm_container_cluster.iks_cluster.region}"
  description = "ID of the resource group that was created."
  depends_on  = ["ibm_container_cluster.iks_cluster"]
}

output "iks_ingress_hostname" {
  value       = "${ibm_container_cluster.iks_cluster.ingress_hostname}"
  description = "Ingress hostname of the IKS cluster."
  depends_on  = ["ibm_container_cluster.iks_cluster"]
}

output "iks_config_file_path" {
  value       = "${ibm_container_cluster.iks_cluster.config_file_path}"
  description = "Path to the config file for the cluster."
  depends_on  = ["ibm_container_cluster.iks_cluster"]
}
