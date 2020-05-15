output "cluster_id" {
  value = "${aws_elasticache_replication_group.cluster.id}"
}

output "cluster_primary_endpoint" {
  value = "${aws_elasticache_replication_group.cluster.primary_endpoint_address}"
}
