resource "aws_ecr_repository" "repository" {
  count = "${length(var.repo_names)}"
  name = "${var.repo_names[count.index]}"
  image_tag_mutability = "${var.tag_mutability}"

  image_scanning_configuration {
    scan_on_push = "${var.scan_on_push}"
  }
}
