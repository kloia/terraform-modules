resource "aws_sfn_state_machine" "state_machine" {
  name     = "${var.state_machine_name}"
  role_arn = "${aws_iam_role.iam_for_sfn.arn}"
  definition = "${var.definition_content}"
}