provider "aws" {
  region = "${var.region}"
}

resource "aws_kms_key" "kms_key" {
  description             = "${var.description}"
  deletion_window_in_days = "${var.deletion_window_in_days}"
  is_enabled = "${var.is_enabled}"
  key_usage = "${var.key_usage}"
  policy = "${var.policy}"
}
