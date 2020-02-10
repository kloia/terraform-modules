resource "aws_ecr_repository" "repository" {
  name                 = "${var.repository_name}"
  image_tag_mutability = "${var.tag_mutability}"

  image_scanning_configuration {
    scan_on_push = "${var.scan_on_push}"
  }
}

resource "aws_ecr_repository_policy" "repo_policy" {
  repository = "${aws_ecr_repository.repository.name}"

  policy = "${var.repo_policy}"
}