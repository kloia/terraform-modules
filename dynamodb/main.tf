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
  billing_mode     = "${var.billing_mode}"
  hash_key         = "${var.hash_key}"
  range_key        = "${var.range_key}"
  attribute        = ["${local.attributes}"]

  tags {
    Name = "${var.name}"
    Managed_By = "Terraform"
  }
}
