output "tools_namespace_name" {
  value       = "${data.local_file.tools_namespace.content}"
  description = "Tools namespace name"
}

output "dev_namespace_name" {
  value       = "${data.local_file.dev_namespace.content}"
  description = "Development namespace name"
}

output "test_namespace_name" {
  value       = "${data.local_file.test_namespace.content}"
  description = "Test namespace name"
}

output "staging_namespace_name" {
  value       = "${data.local_file.staging_namespace.content}"
  description = "Staging namespace name"
}
