locals {
  attributes = [
    {
      name = "${var.range_key}"
      type = "${var.range_key_type}"
    },
    {
      name = "${var.hash_key}"
      type = "${var.hash_key_type}"
    }
  ]
}

resource "aws_dynamodb_table" "default" {
  name             = "${var.name}"
  hash_key         = "${var.hash_key}"
  range_key        = "${var.range_key}"
  billing_mode     = "${var.billing_mode}"
  attribute        = ["${local.attributes}"]
  stream_enabled = "${var.is_stream_enabled}"
  stream_view_type = "${var.stream_view_type}"

  replica {
    region_name    = "${var.replication_region}"
  }

  tags {
    Name = "${var.name}"
    Managed_By = "Terraform"
  }
}