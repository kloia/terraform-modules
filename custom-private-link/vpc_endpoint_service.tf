resource "aws_vpc_endpoint_service" "custom_service" {

  acceptance_required        = "${var.acceptance_required}"
  network_load_balancer_arns = "${var.nlb_arns}"

  tags = {
    Environment = "${var.tag_environment}"
  }
}

resource "aws_vpc_endpoint_service_allowed_principal" "allow_me_to_foo" {
  vpc_endpoint_service_id = "${aws_vpc_endpoint_service.custom_service.id}"
  principal_arn           = "${data.aws_caller_identity.current.arn}"
}

data "aws_caller_identity" "current" {}


