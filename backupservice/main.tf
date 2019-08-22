resource "aws_backup_vault" "aws_backup_vault" {
  name        = "${var.servicename}_backup_vault"
  kms_key_arn = "${var.kms_arn}"
}

resource "aws_iam_role" "backup_service_role" {
  name               = "${var.servicename}_backup_service_role"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": ["sts:AssumeRole"],
      "Effect": "allow",
      "Principal": {
        "Service": ["backup.amazonaws.com"]
      }
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "backup_role_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = "${aws_iam_role.backup_service_role.name}"
}

resource "aws_backup_plan" "backup_service_plan" {
  name = "${var.servicename}_backup_service_plan"

  rule {
    rule_name         = "${var.servicename}_backup_service_rule"
    target_vault_name = "${aws_backup_vault.aws_backup_vault.name}"
    schedule          = "${var.cron_expression}"

    lifecycle {
      delete_after = "${var.delete_after}"
    }
  }

}


resource "aws_backup_selection" "backup_service_selection" {
  iam_role_arn = "${aws_iam_role.backup_service_role.arn}"
  name         = "${var.servicename}_backup_selection"
  plan_id      = "${aws_backup_plan.backup_service_plan.id}"

  resources = ["${var.resource_arn}"]
}
