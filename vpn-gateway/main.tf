resource "aws_vpn_gateway" "vpn_gateway" {
  vpc_id = "${var.vpc_id}"
  
  amazon_side_asn = "${var.custom_asn}"

  tags = {
    Name = "${var.tag_name}"
  }

}

output "vpn_gateway_id" {
  value = "${aws_vpn_gateway.vpn_gateway.id}"
}

resource "aws_vpn_connection" "main" {

  vpn_gateway_id      = "${aws_vpn_gateway.vpn_gateway.id}"
  customer_gateway_id = "${aws_customer_gateway.customer_gateway.id}"
  type                = "ipsec.1"
  static_routes_only  = "${var.route_type}"

}


resource "aws_customer_gateway" "customer_gateway" {
  bgp_asn    = "${var.bgp_asn}"
  ip_address = "${var.ip_address}"
  type       = "${var.type}"

  tags = {
    Name = "${var.organization}-customer-gateway"
  }
}

output "customer_gateway_id" {
  value = "${aws_customer_gateway.customer_gateway.id}"
}

resource "aws_vpn_gateway_attachment" "vpn_attachment" {
  vpc_id         = "${var.vpc_id}"
  vpn_gateway_id = "${aws_vpn_gateway.vpn_gateway.id}"
}