variable "test_administrators" {
  description = "Assign these users as Administrators of the resource group"
  type = "list"
}

data "ibm_resource_group" "test_resource_group" {
  name = "test"
}

resource "ibm_iam_user_policy" "administrator_policies" {
  count = "${length(var.test_administrators)}"
  ibm_id  = "${element(var.test_administrators, count.index)}"
  roles  = ["Administrator"]

  resources = [{
    resource_group_id = "${data.ibm_resource_group.test_resource_group.id}"
  }]
}
