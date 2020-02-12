resource "aws_ecr_repository_policy" "repo_policy" {
  count = "${length(var.repo_names)}"
  repository = "${var.repo_names[count.index]}"

  policy = "${var.repo_policy}"

}