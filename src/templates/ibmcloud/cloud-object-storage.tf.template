data "ibm_resource_group" "iks_resource_group" {
  name = "test"
}

resource "ibm_resource_instance" "cos_instance" {
  name              = "${data.ibm_resource_group.iks_resource_group.name}-cos"
  service           = "cloud-object-storage"
  plan              = "standard"
  location          = "global"
  resource_group_id = "${data.ibm_resource_group.iks_resource_group.id}"
}
