
data "aws_vpc" "host_vpc" {
  id = "${var.vpc["host_vpc_id"]}"
}

data "aws_route_tables" "host_vpc" {
  vpc_id  =  "${var.vpc["host_vpc_id"]}"

}

data "aws_vpc" "requested_vpc" {
  id = "${var.vpc["requested_vpc_id"]}"
}

data "aws_route_tables" "requested_vpc" {
  vpc_id  =  "${var.vpc["requested_vpc_id"]}"

}