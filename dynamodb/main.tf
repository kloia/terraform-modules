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
  write_capacity   = 5
  read_capacity    = 5
  hash_key         = "${var.hash_key}"
  range_key        = "${var.range_key}"
  billing_mode     = "${var.billing_mode}"
  attribute        = ["${local.attributes}"]
  stream_enabled = "${var.is_stream_enabled}"
  stream_view_type = "NEW_AND_OLD_IMAGES"

  replica {
    region_name    = "${var.replication_region}"
  }

  tags {
    Name = "${var.name}"
    Managed_By = "Terraform"
  }
}


