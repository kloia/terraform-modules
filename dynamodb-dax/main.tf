resource "aws_dax_cluster" "dax_cluster" {

  cluster_name       = "${var.dax_cluster_name}"
  iam_role_arn       = "${aws_iam_role.dax_role.arn}"
  node_type          = "${var.instance_type}"
  replication_factor = "${var.replication_factor}"
  parameter_group_name = "${aws_dax_parameter_group.parameter_group.name}"
  subnet_group_name = "${aws_dax_subnet_group.subnet_group_name.name}"
  availability_zones  = ["${data.aws_availability_zones.available.names}"]
  server_side_encryption {
    enabled = "${var.encryption_enabled}"
  }
}

resource "aws_dax_parameter_group" "parameter_group" {
  name = "${var.dax_cluster_name}_parameter_group"

  parameters {
    name  = "query-ttl-millis"
    value = "${var.query_ttl_millis}"
  }

  parameters {
    name  = "record-ttl-millis"
    value = "${var.record_ttl_millis}"
  }
}

resource "aws_dax_subnet_group" "subnet_group_name" {
  name       = "${var.dax_cluster_name}_subnet_group_name"
  subnet_ids = "${var.dax_subnet_lists}"
}

data "aws_availability_zones" "available" {
  state = "available"
}
