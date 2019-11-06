resource "aws_vpc_endpoint" "s3" {
  vpc_id       = "${var.vpc_id}"
  service_name = "${var.service_name}"

  tags = {
    Environment = "${var.env_tag}"
  }
}