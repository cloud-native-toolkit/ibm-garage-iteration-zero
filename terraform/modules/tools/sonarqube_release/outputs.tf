output "ingress_host" {
  description = "The ingress host for the SonarQube instance"
  value       = "${local.ingress_host}"
  depends_on  = ["null_resource.sonarqube_release"]
}

output "ingress_url" {
  description = "The ingress url for the SonarQube instance"
  value       = "${local.ingress_url}"
  depends_on  = ["null_resource.sonarqube_release"]
}

output "secret_name" {
  description = "The name of the secret created to store the credentials and url"
  value       = "${local.secret_name}"
  depends_on  = ["null_resource.sonarqube_release"]
}
