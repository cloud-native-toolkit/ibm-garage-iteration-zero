output "tiller_namespace" {
  value       = "${kubernetes_service_account.tiller_service_account.metadata.0.namespace}"
  description = "Namespace of the Tiller Deployment."
  depends_on  = ["kubernetes_cluster_role_binding.tiller_admin_binding"]
}

output "tiller_service_account_name" {
  value       = "${kubernetes_service_account.tiller_service_account.metadata.0.name}"
  description = "Name of the Tiller Service Account."
  depends_on  = ["kubernetes_cluster_role_binding.tiller_admin_binding"]
}

output "iks_cluster_config_file" {
  value       = "${data.ibm_container_cluster_config.iks_cluster.config_file_path}"
  description = "Directory for Kube configuration"
  depends_on  = ["kubernetes_cluster_role_binding.tiller_admin_binding"]
}
