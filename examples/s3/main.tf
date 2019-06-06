module "my_s3_bucket" {
    source = "../../s3/"
    name = "access-privatet"
    acl = "private"
    tag_name = "tag1"
    tag_env = "tag1-env"
    versioning = true
    force_destroy = true
    is_enabled = true
    prefix = "log/"
    life_cycle_id = "log"
}

output "bucket_domain_name" {
  value = "${module.my_s3_bucket.bucket_domain_name }"
}