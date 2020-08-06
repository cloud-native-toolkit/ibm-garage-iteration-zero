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
}

variable "login_password" {
  type        = string
  description = "The password to log in to openshift"
}

variable "server_url" {
  type        = string
  description = "The url to the server"
}
