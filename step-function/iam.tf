resource "aws_iam_role_policy" "step_function_policy" {
  name = "${var.state_machine_name}_execution_policy"
  role = "${aws_iam_role.iam_for_sfn.id}"

  policy = "${var.iam_policy_content}"
}

data "aws_iam_policy_document" "step_function_assume_role_document" {

  statement {
    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "Service"
      identifiers = [
        "states.${var.region}.amazonaws.com",
        "events.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "iam_for_sfn" {
  name = "${var.state_machine_name}-assume-role"
  assume_role_policy = "${data.aws_iam_policy_document.step_function_assume_role_document.json}"
}