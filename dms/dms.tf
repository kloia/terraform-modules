data "aws_availability_zones" "available" {
  state = "available"
}


resource "aws_dms_replication_instance" "dms_replication_instance" {
  allocated_storage = var.allocated_storage

  apply_immediately            = var.apply_immediately
  auto_minor_version_upgrade   = var.minor_version_upgrade
  availability_zone            = element(data.aws_availability_zones.available.names, 0)
  engine_version               = var.engine_version
  kms_key_arn                  = aws_kms_key.dms_customer_key[0].arn
  multi_az                     = var.is_multi_az
  preferred_maintenance_window = var.maintaince_window
  publicly_accessible          = var.publicly_accessible
  replication_instance_class   = var.instance_class
  replication_instance_id      = var.instance_id
  replication_subnet_group_id  = aws_dms_replication_subnet_group.dms_subnet_group.id

  tags = var.tags

  vpc_security_group_ids = [
    for sec_group in var.security_groups :
    sec_group
  ]
}

resource "aws_kms_key" "dms_customer_key" {
  count                   = var.use_default_kms == true ? 1 : 0
  description             = "DMS custom managed key"
  deletion_window_in_days = var.deletion_window
}


resource "aws_dms_replication_subnet_group" "dms_subnet_group" {
  replication_subnet_group_description = "Dms Replication Subnet Group"
  replication_subnet_group_id          = "dms-mongodb-dynamodb-subnet-group"

  subnet_ids = [
    for subnet_id in var.subnet_ids :
    subnet_id
  ]
}
