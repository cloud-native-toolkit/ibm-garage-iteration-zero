data "ibm_resource_group" "appid_resource_group" {
  name = "${var.resource_group_name}"
}

resource "ibm_resource_instance" "appid_instance" {
  name              = "${data.ibm_resource_group.appid_resource_group.name}-appid"
  service           = "appid"
  plan              = "lite"
  location          = "us-south"
  resource_group_id = "${data.ibm_resource_group.appid_resource_group.id}"
}
