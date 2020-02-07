resource "aws_vpc_endpoint" "custom_service" {
  vpc_id            = "${var.vpc_id}"
  service_name      = "${aws_vpc_endpoint_service.custom_service.service_name}"
  vpc_endpoint_type = "Interface"

  security_group_ids = "${var.security_group_ids}"

  subnet_ids          = "${var.subnet_ids}"
  private_dns_enabled = false
}


data "aws_route53_zone" "internal" {
  name         = "${var.hosted_zone}"
  private_zone = true
  vpc_id       = "${var.vpc_id}"
}

resource "aws_route53_record" "custom_service" {
  zone_id = "${data.aws_route53_zone.internal.zone_id}"
  name    = "${var.service_dns_prefix}.${data.aws_route53_zone.internal.name}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${lookup(aws_vpc_endpoint.custom_service.dns_entry[0], "dns_name")}"]
}



