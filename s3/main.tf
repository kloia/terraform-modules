resource "aws_s3_bucket" "b_lifecyle" {

  bucket = "${var.name}"
  acl    = "${var.acl}"

  tags = {
          Name = "${var.tag_name}"
          Deployment = "${var.tag_deployment}"
          KubernetesCluster = "${var.tag_kubernetes_cluster}"
          Organisation =  "${var.tag_organisation}"
          Project = "${var.tag_project}"
          DeploymentCode =  "${var.tag_deployment_code}"

  }

  versioning {
    enabled = "${var.versioning}"
  }


  lifecycle_rule {
    
    id      = "${var.tag_name}-lf-id"
    enabled = "${var.is_enabled}"

    prefix = ""

    transition {
      days          = "${var.short_storage_day}"
      storage_class = "${var.storage_class}"
    }

    transition {
      days          = "${var.long_storage_day}"
      storage_class = "${var.long_storage_class}"
    }

    expiration {
      days = "${var.expiration}"
    }
  }


  force_destroy = "${var.force_destroy}"
}

output "bucket_domain_name" {
  value = "${aws_s3_bucket.b_lifecyle.bucket }"
}


output "s3_origin_id" {
  value = "${aws_s3_bucket.b_lifecyle.bucket_domain_name }"
}



