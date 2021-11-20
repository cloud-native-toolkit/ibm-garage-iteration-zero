module "dev_cluster" {
  source = "github.com/cloud-native-toolkit/terraform-k8s-ocp-cluster?ref=v2.4.5"

  login_user              = var.login_user
  login_password          = var.login_password
  login_token             = var.login_token
  server_url              = var.server_url
  cluster_region          = var.region
  resource_group_name     = var.resource_group_name
}

resource null_resource write_kubeconfig {
  triggers = {
    always = timestamp()
  }

  provisioner "local-exec" {
    command = "echo -n '${module.dev_cluster.platform.kubeconfig}' > .kubeconfig"
  }
}
