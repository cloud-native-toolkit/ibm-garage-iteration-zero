output "ingress_host" {
  description = "The ingress host for the Jenkins instance"
  value       = "${local.ingress_host}"
  depends_on  = ["null_resource.jenkins_release_openshift", "null_resource.jenkins_release_iks"]
}

output "ingress_url" {
  description = "The ingress url for the Jenkins instance"
  value       = "${local.ingress_url}"
  depends_on  = ["null_resource.jenkins_release_openshift", "null_resource.jenkins_release_iks"]
}

output "secret_name" {
  description = "The name of the secret created to store the credentials and url"
  value       = "${local.secret_name}"
  depends_on  = ["null_resource.jenkins_release_openshift", "null_resource.jenkins_release_iks"]
}
