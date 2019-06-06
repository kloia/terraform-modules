resource "aws_route53_zone" "main" {
  name    = "${var.domain}"
  comment = "${var.domain} Domain"
}

resource "aws_route53_record" "ns" {
  count = "${var.record_ns}"
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "${var.name}"
  type    = "${var.type}"
  ttl     = "${var.ttl}"
  

  records = [
      "${aws_route53_zone.main.name_servers.0}",
      "${aws_route53_zone.main.name_servers.1}",
      "${aws_route53_zone.main.name_servers.2}",
      "${aws_route53_zone.main.name_servers.3}",
    ]

}

resource "aws_route53_record" "cname" {
  count = "${var.record_cname}"
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "${var.name}"
  type    = "${var.type}"
  ttl     = "${var.ttl}"
  
  set_identifier = "${var.set_identifier}"

  weighted_routing_policy {
    weight = "${var.weight}"
  }

  records = ["${var.records}"]
}


resource "aws_route53_record" "default" {
  count = "${var.other_record}"
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "${var.name}"
  type    = "${var.type}"
  ttl     = "${var.ttl}"
  
  set_identifier = "${var.set_identifier}"

  weighted_routing_policy {
    weight = "${var.weight}"
  }

  records = ["${var.records}"]
}


output "cluster_name" {
  value = "${aws_route53_zone.main.name}"
}

output "ns_output" {
  value = "${aws_route53_zone.main.name_servers}"
}

output "zone_id" {
  value = "${aws_route53_zone.main.zone_id}"
}
