module "my_cdn" {
    source = "../../cloudfront/"
    default_root_object = "index.html"
    aliases = ["cdn.testimtest.com"]
    domain_name = "${module.my_s3_bucket.bucket_domain_name}"
    origin_id = "${module.my_s3_bucket.s3_origin_id}"
    restriction_type = "whitelist"
    locations        = ["US", "CA", "GB", "DE"]
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${module.my_s3_bucket.s3_origin_id}"
    headers = ["Origin"]
}

module "my_s3_bucket" {
    source = "../../s3/"
    name = "testimtest-bucket-9"
    acl = "private"
    tag_name = "tag1"
    tag_env = "tag1-env"
    versioning = true
    force_destroy = true
    is_enabled = true
    prefix = ""
    life_cycle_id = "delete 30 days when tag DELETE = 30"
}

