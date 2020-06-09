resource "aws_db_subnet_group" "subnet_group" {
  name        = "${var.name}-subnet-group"
  description = "${var.environment} Aurora Rds Subnet Group"
  subnet_ids  = ["${var.subnets}"]

  tags = {
    Name = "${var.name}"
  }
}

resource "aws_rds_cluster" "rds_cluster" {
  global_cluster_identifier           = "${var.global_cluster_identifier}"
  cluster_identifier                  = "${var.name}"
  replication_source_identifier       = "${var.replication_source_identifier}"
  source_region                       = "${var.source_region}"
  engine                              = "${var.engine}"
  engine_mode                         = "${var.engine_mode}"
  engine_version                      = "${var.engine_version}"
  enable_http_endpoint                = "${var.enable_http_endpoint}"
  kms_key_id                          = "${var.kms_key_id}"
  database_name                       = "${var.database_name}"
  master_username                     = "${var.username}"
  master_password                     = "${var.password}"
  final_snapshot_identifier           = "${var.final_snapshot_identifier_prefix}-${var.name}"
  skip_final_snapshot                 = "${var.skip_final_snapshot}"
  deletion_protection                 = "${var.deletion_protection}"
  backup_retention_period             = "${var.backup_retention_period}"
  preferred_backup_window             = "${var.preferred_backup_window}"
  preferred_maintenance_window        = "${var.preferred_maintenance_window}"
  port                                = "${var.port}"
  db_subnet_group_name                = "${aws_db_subnet_group.subnet_group.id}"
  vpc_security_group_ids              = ["${aws_security_group.this.*.id}"]
  snapshot_identifier                 = "${var.snapshot_identifier}"
  storage_encrypted                   = "${var.storage_encrypted}"
  apply_immediately                   = "${var.apply_immediately}"
  db_cluster_parameter_group_name     = "${var.db_cluster_parameter_group_name}"
  copy_tags_to_snapshot               = "${var.copy_tags_to_snapshot}"

  tags = "${var.tags}"

}

resource "aws_rds_cluster_instance" "this" {
  count = "${var.replica_scale_enabled ? var.replica_scale_min : var.replica_count}"
  identifier                      = "${var.name}-${count.index + 1}"
  cluster_identifier              = "${aws_rds_cluster.rds_cluster.id}"
  engine                          = "${var.engine}"
  engine_version                  = "${var.engine_version}"
  instance_class                  = "${var.instance_type}"
  publicly_accessible             = "${var.publicly_accessible}"
  db_subnet_group_name            = "${aws_db_subnet_group.subnet_group.id}"
  db_parameter_group_name         = "${var.db_parameter_group_name}"
  preferred_maintenance_window    = "${var.preferred_maintenance_window}"
  apply_immediately               = "${var.apply_immediately}"
  auto_minor_version_upgrade      = "${var.auto_minor_version_upgrade}"
  performance_insights_enabled    = "${var.performance_insights_enabled}"
  performance_insights_kms_key_id = "${var.performance_insights_kms_key_id}"

  tags = "${var.tags}"
}


data "aws_iam_policy_document" "monitoring_rds_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}


resource "aws_security_group" "this" {

  name_prefix = "${var.organization}-aurora-rds-${var.environment}-security-group"
  vpc_id      = "${var.vpc_id}"

  description = "RDS Aurora ${var.organization}"

  tags = {
    Environment = "${var.environment}"
  }
}


resource "aws_security_group_rule" "cidr_ingress" {

  description       = "Private Subnet CIDR Ingress"
  type              = "ingress"
  from_port         = "${aws_rds_cluster.rds_cluster.port}"
  to_port           = "${aws_rds_cluster.rds_cluster.port}"
  protocol          = "tcp"
  cidr_blocks       = ["${var.allowed_cidr_blocks}"]
  security_group_id = "${aws_security_group.this.id}"
}
