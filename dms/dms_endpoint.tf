resource "aws_dms_endpoint" "mongodb_source" {
  certificate_arn             = "${var.mongodb_cert_arn}"
  database_name               = "${var.mongodb_database_name}"
  endpoint_id                 = "${var.mongodb_endpoint_id}"
  endpoint_type               = "source"
  engine_name                 = "mongodb"
  extra_connection_attributes = var.extra_conn_attr_mongodb
  kms_key_arn                 = aws_kms_key.dms_customer_key[0].arn
  port                        = "${var.mongodb_port}"
  server_name                 = "${var.mongodb_server_name}"
  ssl_mode                    = "${var.ssl_mode}"

  username = "${var.username}"
  password = "${var.password}"

  mongodb_settings {
        extract_doc_id = "${var.extract_doc_id}"
  }
}


resource "aws_dms_endpoint" "dynamodb_target" {
  certificate_arn             = var.mongodb_cert_arn
  endpoint_id                 = var.dynamodb_target_name
  endpoint_type               = "target"
  engine_name                 = "dynamodb"
  extra_connection_attributes = var.extra_conn_attr_dynamodb
  kms_key_arn                 = aws_kms_key.dms_customer_key[0].arn
  service_access_role         = aws_iam_role.dms-access-for-endpoint.arn
  ssl_mode                    = "${var.ssl_mode}"

}