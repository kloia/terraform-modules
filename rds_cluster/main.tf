resource "aws_rds_cluster" "rds_cluster" {
  cluster_identifier = "${var.organization}-serverless-${var.db_identifier}"
  engine             = "${var.engine}"
  engine_version     = "${var.engine_version}"
  engine_mode        = "${var.engine_mode}" //"serverless"
  database_name      = "${var.database_name}" //db
  master_username    = "${var.master_user}"
  master_password    = "${var.master_password}"
  storage_encrypted               = "${var.encrypted}"
  db_cluster_parameter_group_name = "${var.parameter_group}"
  backup_retention_period   = "${var.backup_ret_period}" # days
  preferred_backup_window   = "${var.backup_window}"
  apply_immediately         = "${var.apply_immediately}"
  skip_final_snapshot       = "${var.skip_final_snapshot}"
  final_snapshot_identifier = "${var.final_snapshot_identifier}"
  db_subnet_group_name      = "${var.rds_subnet_group_id}" //aws_db_subnet_group id
  vpc_security_group_ids    = ["${var.vpc_security_group_id}"] //vpc_security_group_id
  enable_http_endpoint      = "${var.is_data_api_enabled}"

  scaling_configuration {
    auto_pause               = "${var.auto_pause}"
    max_capacity             = "${var.max_capacity}"
    min_capacity             = "${var.min_capacity}"
    timeout_action           = "${var.timeout_action}"
    seconds_until_auto_pause = "${var.seconds_until_auto_pause}"
  }

  tags = {
    Name = "${upper(var.tag_project)} RDS Cluster ${var.organization}"
  }
}

output "rds_cluster_endpoint" {
  value = "${aws_rds_cluster.rds_cluster.endpoint}"
}
