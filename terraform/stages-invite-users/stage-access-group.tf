module "invite_users" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-account-users.git?ref=v1.1.0"

  users = split(",", var.users)
}
