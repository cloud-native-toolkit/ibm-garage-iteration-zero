data "ibm_resource_group" "tools_resource_group" {
  name = "${var.resource_group_name}"
}

resource "ibm_resource_instance" "postgresql_instance" {
  name              = "${replace(data.ibm_resource_group.tools_resource_group.name, "/[^a-zA-Z0-9_\\-\\.]/", "")}-postgresql"
  service           = "databases-for-postgresql"
  plan              = "standard"
  location          = "${var.resource_location}"
  resource_group_id = "${data.ibm_resource_group.tools_resource_group.id}"

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}

resource "ibm_resource_key" "postgresql_credentials" {
  name                 = "${data.ibm_resource_group.tools_resource_group.name}-postgresql-key"
  role                 = "Administrator"
  resource_instance_id = "${ibm_resource_instance.postgresql_instance.id}"
}
