
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "CDN origin access identity"
}
resource "aws_cloudfront_distribution" "s3_distribution" {
    origin {

        domain_name = "${var.domain_name}"
        origin_id   = "${var.origin_id}"
        s3_origin_config {
            origin_access_identity = "origin-access-identity/cloudfront/${aws_cloudfront_origin_access_identity.origin_access_identity.id}"
    }
    }

    enabled = "${var.is_enabled}"
    is_ipv6_enabled = "${var.is_ipv6_enabled}"
    default_root_object = "${var.default_root_object}"
    aliases = "${var.aliases}"
    restrictions {    
        geo_restriction {
            restriction_type = "${var.restriction_type}"
            locations        = "${var.locations}"
        }
    }


    
    default_cache_behavior {
        allowed_methods  = "${var.allowed_methods}"
        cached_methods   = "${var.cached_methods}"
        target_origin_id = "${var.target_origin_id}"
        compress         = "${var.compress}"

        forwarded_values {
            headers = ["${var.forward_headers}"]
            query_string = false

            cookies {
                forward           = "${var.forward_cookies}"
            }
        }

        viewer_protocol_policy = "${var.viewer_protocol_policy}"
        default_ttl            = "${var.default_ttl}"
        min_ttl                = "${var.min_ttl}"
        max_ttl                = "${var.max_ttl}"
    }


    viewer_certificate {
        acm_certificate_arn            = "${var.acm_certificate_arn}"
        ssl_support_method             = "sni-only"
        minimum_protocol_version       = "${var.viewer_minimum_protocol_version}"
        cloudfront_default_certificate = "${var.acm_certificate_arn == "" ? true : false}"
  }


}