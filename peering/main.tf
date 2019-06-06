## emirdaas


resource "aws_vpc_peering_connection" "k8s_vpc_peering" {
  count       = "${var.enabled == "true" ? 1 : 0}"
  vpc_id      = "${var.vpc["host_vpc_id"]}"
  peer_vpc_id = "${var.vpc["requested_vpc_id"]}"

  auto_accept = "${var.auto_accept}"

  accepter {
    allow_remote_vpc_dns_resolution = "${var.vpc["verify_dns_resolution_requested_vpc"]}"
  }

  requester {
    allow_remote_vpc_dns_resolution = "${var.vpc["verify_dns_resolution_host_vpc"]}"
  }
}


resource "aws_route" "route_to_hosted_vpc" {

  count                     = "${length(data.aws_route_tables.host_vpc.ids)}"
  route_table_id            = "${data.aws_route_tables.host_vpc.ids[count.index]}"
  destination_cidr_block    = "${data.aws_vpc.host_vpc.cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.k8s_vpc_peering.id}"
}

resource "aws_route" "requested_vpc" {

  count                     = "${length(data.aws_route_tables.requested_vpc.ids)}"
  route_table_id            = "${data.aws_route_tables.requested_vpc.ids[count.index]}"
  destination_cidr_block    = "${data.aws_vpc.requested_vpc.cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.k8s_vpc_peering.id}"
}


### requested vpc subnet receive 
### host vpc subnet recevi  

### routetable id's fetch
### write route table rules between each other . 