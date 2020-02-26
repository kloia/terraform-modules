resource "aws_sfn_state_machine" "state_machine" {
  name     = "${var.state_machine_name}"
  role_arn = "${var.role_arn}"
  definition = "${var.definition_content}"
}