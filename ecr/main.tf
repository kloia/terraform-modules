resource "aws_ecr_repository" "repository" {
  count = "${length(var.repo_names)}"
  name = "${var.repo_names[count.index]}"
  image_tag_mutability = "${var.tag_mutability}"

  image_scanning_configuration {
    scan_on_push = "${var.scan_on_push}"
  }
}

resource "aws_ecr_repository_policy" "repo_policy" {
  count = "${length(var.repo_names)}"
  repository = "${var.repo_names[count.index]}"

  policy = "${var.repo_policy}"
}