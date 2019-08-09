output "ingress_host" {
  description = "The ingress host for the Pact Broker instance"
  value       = "${local.ingress_host}"
  depends_on  = ["null_resource.pactbroker_release"]
}

output "ingress_url" {
  description = "The ingress url for the Pact Broker instance"
  value       = "${local.ingress_url}"
  depends_on  = ["null_resource.pactbroker_release"]
}
