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
