data "ibm_resource_group" "iks_resource_group" {
  name = "test"
}

resource "ibm_resource_instance" "cloudant_instance" {
  name              = "${data.ibm_resource_group.iks_resource_group.name}-cloudant"
  service           = "cloudantnosqldb"
  plan              = "lite"
  location          = "us-south"
  resource_group_id = "${data.ibm_resource_group.iks_resource_group.id}"

  parameters = {
    "location" = "us-south"
    "legacyCredentials" = "false"
    "hipaa" = "false"
  }
}
