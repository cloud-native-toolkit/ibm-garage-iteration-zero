output "name" {
  value       = "${data.local_file.service_account_name.content}"
  description = "Name of the service account that was created"
}
