output "postgresql_service_account_username" {
  value       = "${ibm_resource_key.postgresql_credentials.credentials.connection.postgres.authentication.username}"
  description = "Username for the Databases for PostgreSQL service account."
}

output "postgresql_service_account_password" {
  value       = "${ibm_resource_key.postgresql_credentials.credentials.connection.postgres.authentication.password}"
  description = "Password for the Databases for PostgreSQL Sservice account."
}

output "postgresql_hostname" {
  value       = "${ibm_resource_key.postgresql_credentials.credentials.connection.postgres.hosts.0.hostname}"
  description = "Hostname for the Databases for PostgreSQL instance."
}

output "postgresql_port" {
  value       = "${ibm_resource_key.postgresql_credentials.credentials.connection.postgres.hosts.0.port}"
  description = "Port for the Databases for PostgreSQL instance."
}

output "postgresql_database_name" {
  value       = "${ibm_resource_key.postgresql_credentials.credentials.connection.postgres.database}"
  description = "Database name for the Databases for PostgreSQL instance."
}
