resource "aws_ecr_repository" "this" {
  count                = var.enabled ? length(var.repo_names) : 0
  name                 = var.repo_names[count.index]
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.scan_images_on_push
  }

  tags = var.tags
}


resource "aws_ecr_lifecycle_policy" "default" {
  count      = var.enabled ? length(var.repo_names) : 0
  repository = aws_ecr_repository.this[count.index].name

  policy = "${jsonencode(var.ecr_lifecycle_policies)}"
}


# Allows specific principals to pull images
data "aws_iam_policy_document" "read_only" {
  count = var.enabled ? length(var.repo_names) : 0
  statement {
    sid    = "ElasticContainerRegistryOnlyPull"
    effect = "Allow"

    principals {
      identifiers = var.principals_readonly_access
      type        = "AWS"
    }

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
      "ecr:DescribeImageScanFindings",
    ]
  }
}

# Allows specific principals to push and pull images
data "aws_iam_policy_document" "full_access" {
  count = var.enabled ? length(var.repo_names) : 0

  statement {
    sid    = "ElasticContainerRegistryPushAndPull"
    effect = "Allow"

    principals {
      identifiers = var.principals_full_access
      type        = "AWS"
    }

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
      "ecr:DescribeImageScanFindings",
      "ecr:StartImageScan",
    ]
  }
}

data "aws_iam_policy_document" "empty" {
  count = var.enabled ? length(var.repo_names) : 0
}

data "aws_iam_policy_document" "resource" {
  count         = var.enabled ? length(var.repo_names) : 0
  source_json   = length(var.principals_readonly_access) > 0 ? join("", [data.aws_iam_policy_document.read_only[0].json]) : join("", [data.aws_iam_policy_document.empty[0].json])
  override_json = length(var.principals_full_access) > 0 ? join("", [data.aws_iam_policy_document.full_access[0].json]) : join("", [data.aws_iam_policy_document.empty[0].json])
}

resource "aws_ecr_repository_policy" "default" {
  count      = var.enabled ? length(var.repo_names) : 0
  repository = aws_ecr_repository.this[count.index].name
  policy     = join("", data.aws_iam_policy_document.resource.*.json)
}
