data "aws_db_snapshot" "db_snapshot" {
    most_recent = true
    db_instance_identifier = "${var.db_instance_identifier}"
}

data "aws_kms_key" "db_kms_key_id" {
  key_id = "${var.kms_key_id}"
}

resource "aws_db_instance" "db_instance_pitr" {
  instance_class       = "${var.instance_type}"
  identifier           = "${var.db_instance_identifier}"
  username             = "${var.db_username}"
  password             = "${var.db_password}"
  db_subnet_group_name = "${var.db_subnet_group_name}"
  snapshot_identifier  = "${data.aws_db_snapshot.db_snapshot.id}"
  skip_final_snapshot = "${var.skip_last_snapshot}"


  allocated_storage   = "${var.allocated_storage}"
  engine              = "${var.engine}"
  engine_version      = "${var.engine_version}"
  name                = "${var.db_name}"

  port                = "${var.port}"

  vpc_security_group_ids = "[${var.security_groups}]"

  db_subnet_group_name      = "${var.db_subnet_group_name}"
  parameter_group_name      = "${var.db_param_group}"

  multi_az                  = "${var.multi_az}"
  storage_type              = "${var.storage_type}"
  iops                      = "${var.iops}"
  publicly_accessible       = "${var.publicly_accessible}"

  allow_major_version_upgrade = "${var.allow_major_version_upgrade}"
  auto_minor_version_upgrade  = "${var.auto_minor_version_upgrade}"
  apply_immediately           = "${var.apply_immediately}"
  maintenance_window          = "${var.maintenance_window}"

  kms_key_id                  = "${data.aws_kms_key.db_kms_key_id.arn}"
  storage_encrypted           = "${var.storage_encrypted}"

  backup_retention_period     = "${var.backup_retention_period}"
  backup_window               = "${var.backup_window}"

  copy_tags_to_snapshot       = "${var.copy_tags_to_snapshot}"

  lifecycle {
    ignore_changes = ["username","password"]
  }

}