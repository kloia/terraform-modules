locals {
  # Define the common tags for all resources
  common_tags = "${var.tags}"
}

resource "aws_vpc" "my_vpc" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_support = "${var.enable_dns_support}"
    enable_dns_hostnames  = "${var.enable_dns_hostnames}"

    tags = "${merge(
      map(
        "Name", "${var.cluster_name}",
        "kubernetes.io/cluster/${var.cluster_name}", "shared",
      ),
      local.common_tags
    )}"

}

### SUBNETS

locals {
  vpc_id = "${aws_vpc.my_vpc.id}"
}
data "aws_availability_zones" "available" {
    
}
### accessing availability zones for subnets

resource "aws_subnet" "public" {
  count = "${var.public_subnet_count}"
  vpc_id                  = "${local.vpc_id}"
  cidr_block        = "${cidrsubnet(signum(length(aws_vpc.my_vpc.cidr_block)) == 1 ? var.vpc_cidr : aws_vpc.my_vpc.cidr_block, ceil(log(var.public_subnet_count * 2, 2)), var.public_subnet_count+count.index)}"
  availability_zone       = "${element(data.aws_availability_zones.available.names, count.index)}"

    tags = "${merge(
      map(
        "Name", "${var.cluster_name}",
        "kubernetes.io/cluster/${var.cluster_name}", "shared",
      ),
      local.common_tags
    )}"


}


resource "aws_subnet" "private" {

  count = "${var.private_subnet_count}"
  vpc_id                  = "${local.vpc_id}"

  cidr_block        = "${cidrsubnet(signum(length(aws_vpc.my_vpc.cidr_block)) == 1 ? aws_vpc.my_vpc.cidr_block : aws_vpc.my_vpc.cidr_block, ceil(log(var.private_subnet_count * 2, 2)), count.index)}"

  availability_zone       =  "${element(data.aws_availability_zones.available.names, count.index)}"

    tags = "${merge(
      map(
        "Name", "${var.cluster_name}",
        "kubernetes.io/cluster/${var.cluster_name}", "shared",
      ),
      local.common_tags
    )}"
}

####



### Public Route Tables 
resource "aws_internet_gateway" "gw" {
  vpc_id                  = "${local.vpc_id}"
  
    tags = "${merge(
      map(
        "Name", "${var.cluster_name}",
        "kubernetes.io/cluster/${var.cluster_name}", "shared",
      ),
      local.common_tags
    )}"

}

resource "aws_eip" "vpc_eip" {
  vpc      = true
  depends_on = ["aws_internet_gateway.gw"]
}
 resource "aws_route_table" "public" { ### Public
  vpc_id                  = "${local.vpc_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }
  
  
    tags = "${merge(
      map(
        "Name", "${var.cluster_name}",
        "kubernetes.io/cluster/${var.cluster_name}", "shared",
        ),
      local.common_tags
    )}"


}


resource "aws_route" "public_internet_gateway" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.gw.id}"

}

resource "aws_route_table_association" "association_public" {### public (asso), route to the IGW
  count          = "${var.public_subnet_count}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"

}
resource "aws_route_table_association" "association_private" {### private (asso) 
  count          = "${var.private_subnet_count}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${aws_route_table.private.id}"

}

resource "random_integer" "p_subnet_id" {
  min     = 0
  max     = "${var.public_subnet_count}"
}


resource "aws_nat_gateway" "vpc_nat" {

  allocation_id = "${aws_eip.vpc_eip.id}"
  subnet_id     = "${element(aws_subnet.public.*.id, (random_integer.p_subnet_id.result))}"
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.my_vpc.id}"
  
  tags = "${merge(
        local.common_tags,
        map(
        "kubernetes", "awesome-app-server",
        "Role", "server"
        )
  )}"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.vpc_nat.id}"
  }

}

output "azs" {
  value = "${data.aws_availability_zones.available.names}"
}

output "vpc_id" {
  value = "${aws_vpc.my_vpc.id}"
}
output "private_route_table_ids" {
  value = ["${aws_route_table.private.*.id}"]
}

output "private_subnet_cidrs" {
  value = ["${aws_subnet.private.*.cidr_block}"]
}

output "public_subnet_cidrs" {
  value = ["${aws_subnet.public.*.cidr_block}"]
}


output "vpc_cidr" {
  value = "${aws_vpc.my_vpc.cidr_block}"
}
output "public_subnets_ids" {
  value = ["${aws_subnet.public.*.id}"]
}

output "private_subnets_ids" {
  value = ["${aws_subnet.private.*.id}"]
}
output "nat_gateway_id" {
  value = ["${aws_nat_gateway.vpc_nat.id}"]
}

output "igw_id" {
  value = ["${aws_internet_gateway.gw.id}"]
}