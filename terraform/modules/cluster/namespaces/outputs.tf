output "tools_namespace_name" {
  value       = "${var.tools_namespace}"
  description = "Tools namespace name"
  depends_on  = ["null_resource.create_namespaces"]
}

output "dev_namespace_name" {
  value       = "${var.dev_namespace}"
  description = "Development namespace name"
  depends_on  = ["null_resource.create_namespaces"]
}

output "test_namespace_name" {
  value       = "${var.test_namespace}"
  description = "Test namespace name"
  depends_on  = ["null_resource.create_namespaces"]
}

output "staging_namespace_name" {
  value       = "${var.staging_namespace}"
  description = "Staging namespace name"
  depends_on  = ["null_resource.create_namespaces"]
}
