data "aws_db_snapshot" "db_snapshot" {
    most_recent = true
    db_instance_identifier = "${var.db_instance_identifier}"
}

resource "aws_db_instance" "db_uat" {
  instance_class       = "${var.instance_type}"
  identifier           = "${var.db_instance_identifier}"
  username             = "${var.db_username}"
  password             = "${var.db_password}"
  db_subnet_group_name = "${var.db_subnet_group_name}"
  snapshot_identifier  = "${data.aws_db_snapshot.db_snapshot.id}"
  vpc_security_group_ids = "${var.security_groups}"
  skip_final_snapshot = "${var.skip_last_snapshot}"
}