
resource "aws_cloudfront_distribution" "s3_distribution" {
    origin {

        domain_name = "${var.domain_name}"
        origin_id   = "${var.origin_id}"
    
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
        cloudfront_default_certificate = true
    }


}



