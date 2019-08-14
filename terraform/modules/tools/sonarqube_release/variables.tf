
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

variable "plugins" {
  description = "The list of plugins that will be installed on SonarQube"
  type        = "list"
  default     = ["https://binaries.sonarsource.com/Distribution/sonar-typescript-plugin/sonar-typescript-plugin-1.9.0.3766.jar", "https://binaries.sonarsource.com/Distribution/sonar-java-plugin/sonar-java-plugin-5.9.2.16552.jar", "https://github.com/checkstyle/sonar-checkstyle/releases/download/4.21/checkstyle-sonar-plugin-4.21.jar"]
}
