data "ibm_resource_group" "tools_resource_group" {
  name = "${var.resource_group_name}"
}

// SysDig - Monitoring
resource "ibm_resource_instance" "sysdig_instance" {
  name              = "${replace(data.ibm_resource_group.tools_resource_group.name, "/[^a-zA-Z0-9_\\-\\.]/", "")}-sysdig"
  service           = "sysdig-monitor"
  plan              = "graduated-tier"
  location          = "us-south"
  resource_group_id = "${data.ibm_resource_group.tools_resource_group.id}"

  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}

resource "ibm_resource_key" "sysdig_instance_key" {
  name                  = "${replace(data.ibm_resource_group.tools_resource_group.name, "/[^a-zA-Z0-9_\\-\\.]/", "")}-sysdig-key"
  resource_instance_id = "${ibm_resource_instance.sysdig_instance.id}"
  role = "Manager"

  //User can increase timeouts 
  timeouts {
    create = "15m"
    delete = "15m"
  }
}
