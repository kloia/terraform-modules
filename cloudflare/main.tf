data "aws_ssm_parameter" "cloudflare_key" {
  name = "${var.cloudflarekey}"
}

data "aws_ssm_parameter" "cloudflare_email" {
  name = "${var.cloudflareemail}"
}

provider "cloudflare" {
  email = "${data.aws_ssm_parameter.cloudflare_email.value}"
  token = "${data.aws_ssm_parameter.cloudflare_key.value}"
}

resource "cloudflare_record" "cname" {
  count = "${var.count == 0 ? 0 : 1}"
  domain = "${var.cloudflare_domain}"
  name = "${var.cloudflare_domain_name}" 
  value  = "${var.cname_record_address}"
  type   = "CNAME"
  ttl    = "${var.ttl}"
}

resource "cloudflare_record" "ns" {
  count = "${var.use_route53_ns_record == 0 ? length(var.name_servers) : 0 }"
  domain = "${var.cloudflare_domain}"
  name = "${var.cloudflare_domain_name}"
  value  = "${var.name_servers[count.index]}"
  type   = "NS"
  ttl    = 1
}

resource "aws_route53_zone" "cloudflare_zone_main" {
  count = "${var.use_route53_ns_record}"
  name = "${var.cloudflare_domain_ns}"
}


resource "cloudflare_record" "route53_ns" {
  count = "${var.use_route53_ns_record == 0 ? 0 : 4}"
  domain = "${var.cloudflare_domain}"
  name = "${var.cloudflare_domain_ns}"
  value  = "${aws_route53_zone.cloudflare_zone_main.name_servers[count.index]}"
  type   = "NS"
  ttl    = 1
}


