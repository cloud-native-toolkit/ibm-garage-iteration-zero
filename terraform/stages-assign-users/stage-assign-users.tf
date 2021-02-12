module "assign_users" {
  source = "github.com/ibm-garage-cloud/terraform-ibm-add-access-group-users.git?ref=v1.0.0"

  users = split(",", var.users)
  access_groups = split(",", var.access_group_names)
}
