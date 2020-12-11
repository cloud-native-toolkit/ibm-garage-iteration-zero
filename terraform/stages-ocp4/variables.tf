variable "tools_namespace" {
  type        = string
  description = "Namespace for tools"
  default     = "tools"
}

variable "sre_namespace" {
  type        = string
  description = "Namespace for SRE tools"
  default     = "ibm-observe"
}

variable "login_user" {
  type        = string
  description = "The username to log in to openshift"
  default     = ""
}

variable "login_password" {
  type        = string
  description = "The password to log in to openshift"
  default     = ""
}

variable "login_token" {
  type        = string
  description = "The token used to log in to openshift"
  default     = ""
}

variable "server_url" {
  type        = string
  description = "The url to the server"
}

variable "registry_type" {
  type        = string
  description = "The type of image registry (icr, ocp, other, none)"
  default     = "ocp"
}

variable "registry_host" {
  type        = string
  description = "The host that should be used for the image registry"
  default     = ""
}

variable "registry_namespace" {
  type        = string
  description = "The namespace that should be used for the image registry"
  default     = ""
}

variable "registry_user" {
  type        = string
  description = "The username for accessing the image registry"
  default     = ""
}

variable "registry_password" {
  type        = string
  description = "The password for accessing the image registry"
  default     = ""
}

variable "registry_url" {
  type        = string
  description = "The browser url to view the images in the registry"
  default     = ""
}

variable "source_control_type" {
  type        = string
  description = "The type of source control system (github, gitlab, or none)"
  default     = "github"
}

variable "source_control_url" {
  type        = string
  description = "The url to the source control system"
  default     = "https://github.com"
}

variable "storage_class" {
  type        = string
  description = "The storage class of the persistence volume claim"
  default     = ""
}
