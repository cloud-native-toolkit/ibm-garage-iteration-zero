output "name" {
  value       = "${var.service_account_name}"
  description = "Name of the service account that was created"
  depends_on  = ["null_resource.create_serviceaccount", "null_resource.add_ssc_openshift"]
}
