variable "cluster_name" {
  type        = "string"
  description = "The name of the cluster."
}

variable "cluster_config_file_path" {
  type        = "string"
  description = "The path to the config file for the cluster"
}

variable "tools_namespace" {
  type        = "string"
  description = "The tools namespace"
}

variable "dev_namespace" {
  type        = "string"
  description = "The dev namespace"
}

variable "test_namespace" {
  type        = "string"
  description = "The test namespace"
}

variable "staging_namespace" {
  type        = "string"
  description = "The staging namespace"
}

variable "cluster_type" {
  type        = "string"
  description = "The type of cluster that should be created (openshift or kubernetes)"
}

variable "tls_secret_name" {
  type        = "string"
  description = "The name of the secret containing the tls certificate for the cluster"
  default     = ""
}
