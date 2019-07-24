variable "resource_group_name" {
  type        = "string"
  description = "Existing resource group where the IKS cluster will be provisioned."
}

variable "cluster_config_file" {
  type        = "string"
  description = "Cluster config file for Kubernetes cluster."
}

variable "releases_namespace" {
  type        = "string"
  description = "Name of the existing namespace where the Helm Releases will be deployed."
}

variable "cluster_ingress_hostname" {
  type        = "string"
  description = "Ingress hostname of the IKS cluster."
}

variable "ibmcloud_api_key" {
  type        = "string"
  description = "The api key for IBM Cloud access"
}

variable "postgresql_username" {
  type        = "string"
  description = "Username for the Databases for PostgreSQL service account to use for SonarQube."
}

variable "postgresql_password" {
  type        = "string"
  description = "Password for the Databases for PostgreSQL Sservice account to use for SonarQube."
}

variable "postgresql_hostname" {
  type        = "string"
  description = "Hostname for the Databases for PostgreSQL instance to use for SonarQube."
}

variable "postgresql_port" {
  type        = "string"
  description = "Port for the Databases for PostgreSQL instance to use for SonarQube."
}

variable "postgresql_database_name" {
  type        = "string"
  description = "Database name for the Databases for PostgreSQL instance to use for SonarQube."
}

variable "server_url" {
  type        = "string"
  description = "The master url of the server"
}

variable "cluster_type" {
  description = "The cluster type (openshift or kubernetes)"
}

variable "helm_version" {
  description = "The version of the helm chart that should be used"
  type        = "string"
  default     = "2.1.1"
}

variable "service_account_name" {
  description = "The name of the service account that should be used for the deployment"
  type        = "string"
  default     = "default"
}
