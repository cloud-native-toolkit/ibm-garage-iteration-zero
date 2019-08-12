variable "cluster_type" {
  type        = "string"
  description = "The type of cluster that should be created (openshift or kubernetes)"
}

variable "cluster_config_file_path" {
  type        = "string"
  description = "The path to the config file for the cluster"
}

variable "namespace" {
  type        = "string"
  description = "The namespaces in which the service account should be created"
}

variable "service_account_name" {
  type        = "string"
  description = "The name of the service account that will be created"
}

variable "sscs" {
  type        = "list"
  description = "The list of Security Context Contraints to apply to the service account (e.g. anyuid, hostaccess, hostmount-anyuid, nonroot, privileged, restricted)"
}
