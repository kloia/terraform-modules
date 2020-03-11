resource "aws_sfn_state_machine" "state_machine" {
  name     = "${var.state_machine_name}"
  role_arn = "${var.role_arn}"
  definition = "${var.definition_content}"
}

output "state_machine_arn" {
  value = "${aws_sfn_state_machine.state_machine.id}"
}
