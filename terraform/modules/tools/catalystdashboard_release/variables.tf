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

variable "cluster_type" {
  description = "The cluster type (openshift or kubernetes)"
}

variable "jenkins_secret_name" {
  description = "The name of the secret containing the jenkins information"
  default     = "jenkins-access"
}

variable "sonarqube_secret_name" {
  description = "The name of the secret containing the sonarqube information"
  default     = "sonarqube-access"
}

variable "pactbroker_secret_name" {
  description = "The name of the secret containing the pact-broker information"
  default     = "pactbroker-access"
}
