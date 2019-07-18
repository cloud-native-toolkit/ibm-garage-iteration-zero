data "ibm_resource_group" "tools_resource_group" {
  name = "${var.resource_group_name}"
}

resource "ibm_resource_instance" "create_postgresql_instance" {
  count = "${var.server_exists != true ? "1" : "0"}"

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

data "ibm_resource_instance" "postgresql_instance" {
  depends_on        = ["ibm_resource_instance.create_postgresql_instance"]

  name              = "${replace(data.ibm_resource_group.tools_resource_group.name, "/[^a-zA-Z0-9_\\-\\.]/", "")}-postgresql"
  service           = "databases-for-postgresql"
  location          = "${var.resource_location}"
  resource_group_id = "${data.ibm_resource_group.tools_resource_group.id}"
}

resource "ibm_resource_key" "postgresql_credentials" {
  depends_on           = ["ibm_resource_instance.create_postgresql_instance"]
  name                 = "${data.ibm_resource_group.tools_resource_group.name}-postgresql-key"
  role                 = "Administrator"
  resource_instance_id = "${data.ibm_resource_instance.postgresql_instance.id}"
}

locals {
  credentials_file = "${path.cwd}/.tmp/postgres_credentials.json"
  hostname_file    = "${path.cwd}/.tmp/postgres_hostname.val"
  port_file        = "${path.cwd}/.tmp/postgres_port.val"
  username_file    = "${path.cwd}/.tmp/postgres_username.val"
  password_file    = "${path.cwd}/.tmp/postgres_password.val"
  dbname_file      = "${path.cwd}/.tmp/postgres_dbname.val"
}

// This is SUPER kludgy but it works... Need to revisit
resource "local_file" "write_postgres_credentials" {
  content     = "${jsonencode(ibm_resource_key.postgresql_credentials.credentials)}"
  filename = "${local.credentials_file}"
  depends_on = ["ibm_resource_key.postgresql_credentials"]
}

resource "null_resource" "write_hostname" {
  depends_on = ["local_file.write_postgres_credentials"]

  provisioner "local-exec" {
    command = "cat ${local.credentials_file} | sed -E \"s/.*host=([^ ]*).*/\\1/\" > ${local.hostname_file}"
  }
}

resource "null_resource" "write_port" {
  depends_on = ["local_file.write_postgres_credentials"]

  provisioner "local-exec" {
    command = "cat ${local.credentials_file} | sed -E \"s/.*port=([0-9]*).*/\\1/\" > ${local.port_file}"
  }
}

resource "null_resource" "write_username" {
  depends_on = ["local_file.write_postgres_credentials"]

  provisioner "local-exec" {
    command = "cat ${local.credentials_file} | sed -E \"s/.*user=([^ ]*).*/\\1/\" > ${local.username_file}"
  }
}

resource "null_resource" "write_password" {
  depends_on = ["local_file.write_postgres_credentials"]

  provisioner "local-exec" {
    command = "cat ${local.credentials_file} | sed -E \"s/.*PGPASSWORD=([^ ]*).*/\\1/\" > ${local.password_file}"
  }
}

resource "null_resource" "write_dbname" {
  depends_on = ["local_file.write_postgres_credentials"]

  provisioner "local-exec" {
    command = "cat ${local.credentials_file} | sed -E \"s/.*dbname=([^ ]*).*/\\1/\" > ${local.dbname_file}"
  }
}

data "local_file" "username" {
  depends_on = ["null_resource.write_username"]

  filename = "${local.username_file}"
}

data "local_file" "password" {
  depends_on = ["null_resource.write_password"]

  filename = "${local.password_file}"
}

data "local_file" "hostname" {
  depends_on = ["null_resource.write_hostname"]

  filename = "${local.hostname_file}"
}

data "local_file" "port" {
  depends_on = ["null_resource.write_port"]

  filename = "${local.port_file}"
}

data "local_file" "dbname" {
  depends_on = ["null_resource.write_dbname"]

  filename = "${local.dbname_file}"
}
