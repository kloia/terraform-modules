
resource "aws_elasticache_replication_group" "example" {
  automatic_failover_enabled    = "${var.automatic_failover}"
  availability_zones            = ["${var.availability_zones}"]
  replication_group_id          = "${var.tag_environment}-1"
  replication_group_description = "${var.tag_project} ${var.tag_environment} replication group redis "
  node_type                     = "${var.node_type}"
  number_cache_clusters         = "${var.cache_node_count}"
  parameter_group_name          = "${aws_elasticache_parameter_group.redis.name}"
  security_group_ids            = ["${aws_security_group.elasticache_sec_group.id}"]
  subnet_group_name             = "${aws_elasticache_subnet_group.subnet_group.name}"
  port                          = "${var.port}"
  tags {
    "Environment" = "${var.tag_environment}"
    "Project"     = "${var.tag_environment}"
  }
  maintenance_window            = "${var.maintenance_window}"
  snapshot_window               = "${var.snapshot_window}"
  snapshot_retention_limit      = "${var.snapshot_retention_limit}"
  at_rest_encryption_enabled    = "${var.at_rest_encrypt}"
  transit_encryption_enabled    = "${var.transit_encrypt}"

}


resource "aws_elasticache_parameter_group" "redis" {
  name   = "${var.cluster_name}-${var.engine}-${var.tag_environment}-parameter-group"
  family = "${var.redis_parameter_family}"
}


resource "aws_elasticache_subnet_group" "subnet_group" {
  name       = "${var.cluster_name}-${var.engine}-${var.tag_environment}-subnet-group"
  subnet_ids = ["${var.private_subnet_list}"]
}

resource "aws_security_group_rule" "elasticache_redis_sec_rule" {
  type              = "ingress"
  from_port         = "${var.port}"
  to_port           = "${var.port}"
  protocol          = "tcp"
  cidr_blocks       = "${var.custom_cidr_block}"
  security_group_id = "${aws_security_group.elasticache_sec_group.id}"
 
}

resource "aws_security_group" "elasticache_sec_group" {
  name = "${var.cluster_name}-${var.engine}-${var.tag_environment}-security-group"
  tags {
    "Environment" = "${var.tag_environment}"
    "Project"     = "${var.tag_project}"
  }
   vpc_id      = "${var.vpc_id}"
}