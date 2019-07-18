output "ingress_host" {
  description = "The ingress host for the Argo CD instance"
  value       = "${local.ingress_host}"
}
