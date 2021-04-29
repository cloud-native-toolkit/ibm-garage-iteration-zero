module "dev_cluster" {
  source = "github.com/cloud-native-toolkit/terraform-k8s-ocp-cluster?ref=v2.4.4"

  login_user              = var.login_user
  login_password          = var.login_password
  login_token             = var.login_token
  server_url              = var.server_url
}
