output "postgresql_service_account_username" {
  value       = "${data.local_file.username.content}"
  description = "Username for the Databases for PostgreSQL service account."
}

output "postgresql_service_account_password" {
  value       = "${data.local_file.password.content}"
  description = "Password for the Databases for PostgreSQL Sservice account."
  sensitive   = true
}

output "postgresql_hostname" {
  value       = "${data.local_file.hostname.content}"
  description = "Hostname for the Databases for PostgreSQL instance."
}

output "postgresql_port" {
  value       = "${data.local_file.port.content}"
  description = "Port for the Databases for PostgreSQL instance."
}

output "postgresql_database_name" {
  value       = "${data.local_file.dbname.content}"
  description = "Database name for the Databases for PostgreSQL instance."
}
