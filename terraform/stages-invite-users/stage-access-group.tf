module "invite_users" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-account-users.git?ref=v1.1.1"

  users = split(",", var.users)
}
