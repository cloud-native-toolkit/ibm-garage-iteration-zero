data "ibm_resource_group" "iks_resource_group" {
  name = "test"
}

resource "ibm_resource_instance" "postgresql_instance" {
  name              = "${data.ibm_resource_group.iks_resource_group.name}-postgresql"
  service           = "databases-for-postgresql"
  plan              = "standard"
  location          = "us-south"
  resource_group_id = "${data.ibm_resource_group.iks_resource_group.id}"

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}
