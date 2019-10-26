module "my_acm" {
  source = "../../acm"
  domain_name = "elespanyol.online."
  name = "bucket.elespanyol.online."
  validation_method = "DNS"
}
