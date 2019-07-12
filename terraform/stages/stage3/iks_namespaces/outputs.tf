output "tools_namespace_name" {
  value       = "${kubernetes_namespace.tools_namespace.id}"
  description = "Tools namespace name"
  depends_on  = ["ibm_container_cluster_config.iks_cluster"]
}

output "dev_namespace_name" {
  value       = "${kubernetes_namespace.dev_namespace.id}"
  description = "Development namespace name"
  depends_on  = ["ibm_container_cluster_config.iks_cluster"]
}

output "test_namespace_name" {
  value       = "${kubernetes_namespace.test_namespace.id}"
  description = "Test namespace name"
  depends_on  = ["ibm_container_cluster_config.iks_cluster"]
}

output "prod_namespace_name" {
  value       = "${kubernetes_namespace.prod_namespace.id}"
  description = "Production namespace name"
  depends_on  = ["ibm_container_cluster_config.iks_cluster"]
}

