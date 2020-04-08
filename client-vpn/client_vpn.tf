resource "aws_acm_certificate" "client_cert" {
  private_key       = "${file("${path.root}/${var.vpn_addr}/${var.vpn_addr}.key")}"
  certificate_body  = "${file("${path.root}/${var.vpn_addr}/${var.vpn_addr}.crt")}"
  certificate_chain = "${file("${path.root}/${var.vpn_addr}/ca.crt")}"
}


resource "aws_ec2_client_vpn_endpoint" "client_vpn_endpoint" {
  description            = "${var.tag_name}-clientvpn-endpoint"
  server_certificate_arn = "${aws_acm_certificate.client_cert.arn}"
  client_cidr_block      = "${var.client_cidr_block}"
  split_tunnel           = "${var.is_split_tunnel}"
  authentication_options {
    type                       = "${var.auth_type}"
    root_certificate_chain_arn = "${aws_acm_certificate.client_cert.arn}"
  }
  dns_servers = "${var.dns_servers}"

  connection_log_options {
    enabled = "${var.enable_logs}"
    cloudwatch_log_group  = "${aws_cloudwatch_log_group.client_vpn_log_group.name}"
    cloudwatch_log_stream = "${aws_cloudwatch_log_stream.client_vpn_log_stream.name}"
  }

  tags = {
    Name        = "${var.tag_name}"
    Environment = "${var.tag_environment}"
  }
}

resource "aws_ec2_client_vpn_network_association" "client_vpn_network_association_az_0" {
  client_vpn_endpoint_id = "${aws_ec2_client_vpn_endpoint.client_vpn_endpoint.id}"
  subnet_id              = "${var.subnet_list[0]}"
  lifecycle {
    ignore_changes = "subnet_id"
  }
}

resource "aws_ec2_client_vpn_network_association" "client_vpn_network_association_az_1" {
  client_vpn_endpoint_id = "${aws_ec2_client_vpn_endpoint.client_vpn_endpoint.id}"
  subnet_id              = "${var.subnet_list[1]}"
  lifecycle {
    ignore_changes = "subnet_id"
  }
}

resource "aws_ec2_client_vpn_network_association" "client_vpn_network_association_az_2" {
  client_vpn_endpoint_id = "${aws_ec2_client_vpn_endpoint.client_vpn_endpoint.id}"
  subnet_id              = "${var.subnet_list[2]}"
  lifecycle {
    ignore_changes = "subnet_id"
  }
}


resource "null_resource" "authorize-client-vpn-ingress" {
  provisioner "local-exec" {
    command = "aws --region ${var.aws_region} ec2 authorize-client-vpn-ingress --client-vpn-endpoint-id ${aws_ec2_client_vpn_endpoint.client_vpn_endpoint.id} --target-network-cidr 0.0.0.0/0 --authorize-all-groups"
  }

  depends_on = [
    "aws_ec2_client_vpn_endpoint.client_vpn_endpoint",
    "aws_ec2_client_vpn_network_association.client_vpn_network_association_az_0",
    "aws_ec2_client_vpn_network_association.client_vpn_network_association_az_1",
    "aws_ec2_client_vpn_network_association.client_vpn_network_association_az_2",

  ]
}
resource "aws_cloudwatch_log_group" "client_vpn_log_group" {
  name = "${var.tag_name}-client_vpn_log_group"

  tags = {
    Environment = "${var.tag_environment}"
  }
}

resource "aws_cloudwatch_log_stream" "client_vpn_log_stream" {
  name           = "${var.tag_name}_client_vpn_log_stream"
  log_group_name = "${aws_cloudwatch_log_group.client_vpn_log_group.name}"
}

resource "null_resource" "client_vpn_route_internet" {
  count = "${var.is_split_tunnel == false ?  "${length("${var.subnet_list}")}" : 0}"
  provisioner "local-exec" {
    when    = "create"
    command = "aws ec2 create-client-vpn-route --client-vpn-endpoint-id ${aws_ec2_client_vpn_endpoint.client_vpn_endpoint.id} --destination-cidr-block 0.0.0.0/0 --target-vpc-subnet-id ${var.subnet_list[count.index]} --description Internet-Access  --region ${var.aws_region}"
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "aws ec2 delete-client-vpn-route --client-vpn-endpoint-id ${aws_ec2_client_vpn_endpoint.client_vpn_endpoint.id} --destination-cidr-block 0.0.0.0/0 --target-vpc-subnet-id ${var.subnet_list[count.index]}  --region ${var.aws_region}"
  }
}