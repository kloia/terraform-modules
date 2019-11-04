resource "aws_rds_cluster" "rds_cluster" {
  cluster_identifier = "${var.tag_project}-rds-cluster-${var.profile}"
  engine             = "${var.engine}"
  engine_version     = "${var.engine_version}"
  engine_mode        = "${var.engine_mode}" //"serverless"
  database_name      = "${var.database_name}" //db
  master_username    = "${var.master_user}"
  master_password    = "${var.master_password}"
  storage_encrypted  = "${var.encrypted}"

  backup_retention_period = 5 # days
  preferred_backup_window = "03:00-07:00"
  apply_immediately       = true
  skip_final_snapshot     = true

  db_subnet_group_name = "${var.rds_subnet_group_id}" //aws_db_subnet_group id
  vpc_security_group_ids = ["${var.vpc_security_group_id}"] //vpc_security_group_id


  scaling_configuration {
    auto_pause               = "${var.auto_pause}"
    max_capacity             = "${var.max_capacity}"
    min_capacity             = "${var.min_capacity}"
    timeout_action           = "${var.timeout_action}"
    seconds_until_auto_pause = "${var.seconds_until_auto_pause}"
  }

  tags = {
    Name = "${upper(var.tag_project)} RDS Cluster ${var.profile}"
  }
}