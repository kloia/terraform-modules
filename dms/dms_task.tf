resource "aws_dms_replication_task" "test" {
  migration_type           = var.migration_type
  replication_instance_arn = aws_dms_replication_instance.dms_replication_instance.replication_instance_arn
  replication_task_id      = var.replication_task_id
  source_endpoint_arn      = aws_dms_endpoint.mongodb_source.endpoint_arn
  table_mappings           = data.local_file.map_rule_content.content
  replication_task_settings = data.local_file.repl_task_content.content
  target_endpoint_arn = aws_dms_endpoint.dynamodb_target.endpoint_arn
}


data "local_file" "map_rule_content" {
  filename = var.map_rule_path
}

data "local_file" "repl_task_content" {
  filename = var.repl_task_path
}