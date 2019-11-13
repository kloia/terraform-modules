
resource "aws_iam_policy" "dax_policy" {
  name        = "${var.dax_cluster_name}_dax_policy"
  path        = "/"
  description = "Dax policy of ${var.dax_cluster_name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "dynamodb:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}


resource "aws_iam_role" "dax_role" {
  name = "${var.dax_cluster_name}_dax_role"

  assume_role_policy = <<EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "dax.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": ""
        }
      ]
    }
EOF
}

resource "aws_iam_role_policy_attachment" "dax_policy_attachment" {
  role       = "${aws_iam_role.dax_role.name}"
  policy_arn = "${aws_iam_policy.dax_policy.arn}"
}