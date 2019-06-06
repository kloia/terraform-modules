
module "my_route53" {
  source = "../../route53"
  domain = "elespanyol.online"
  name = "cdn"
  records = "cloudfront.osmanim.online"
  type = "CNAME"
  record_cname = 1
}


module "k8s" {
  source = "../../route53"
  domain = "k8s.elespanyol.online"
  name = "k8s.staging.elespanyol.online"
  create = 1
  record_ns = 1
}


output "nsoutput" {
  value = "${module.my_route53.ns_output}"
}



