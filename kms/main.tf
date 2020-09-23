provider "aws" {
  region = "${var.region}"
}

resource "aws_kms_key" "kms_key" {
  description             = "${var.description}"
  deletion_window_in_days = "${var.deletion_window_in_days}"
  is_enabled = "${var.is_enabled}"
  enable_key_rotation = "${var.rotation}"
  key_usage 	      = "${var.key_usage}"
  policy 	      = "${var.policy}"
}

resource "aws_kms_alias" "kms_key_alias" {
  name          = "${var.alias_name}"
  target_key_id = "${aws_kms_key.kms_key.key_id}"
  depends_on    = ["aws_kms_key.kms_key"]
}
