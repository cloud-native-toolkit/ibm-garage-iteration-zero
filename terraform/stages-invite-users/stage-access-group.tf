module "invite_users" {
  source = "github.com/ibm-garage-cloud/terraform-ibm-account-users.git?ref=v1.1.0"

  users = split(",", var.users)
}
