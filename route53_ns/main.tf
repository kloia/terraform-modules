resource "aws_route53_zone" "main" {
  name    = "${var.domain}"
  comment = "${var.domain} Domain"
}

output "ns_output" {
  value = "${aws_route53_zone.main.name_servers}"
}