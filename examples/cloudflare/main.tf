module "my_cloudflare" {
  source = "../../cloudflare"
  domain = "garnett.site"
  name = "bucket"
  cname_record_address = "bucket.garnett.site.s3-website.us-east-2.amazonaws.com"
  use_route53_ns_record = 0
}
