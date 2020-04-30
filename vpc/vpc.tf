resource "aws_vpc" "my_vpc" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_support = "${var.enable_dns_support}"
    enable_dns_hostnames  = "${var.enable_dns_hostnames}"

    tags {
      Name              = "${var.tag_organisation}-${var.tag_project}-vpc"
      Deployment        = "${var.tag_deployment}"
      DeploymentCode    = "${var.tag_deployment_code}"
      KubernetesCluster = "${var.tag_kubernetes_cluster}"
      Organisation      = "${var.tag_organisation}"
      Project           = "${var.tag_project}"
    } 

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

    tags {
        Name = "public-${data.aws_availability_zones.available.names[count.index]}"
        Deployment = "${var.tag_deployment}"
        DeploymentCode = "${var.tag_deployment_code}"
        Organisation =  "${var.tag_organisation}"
        Project = "${var.tag_project}"
        KubernetesCluster = "${var.tag_kubernetes_cluster}"
    }


}


resource "aws_subnet" "private" {

  count = "${var.private_subnet_count}"
  vpc_id                  = "${local.vpc_id}"

  cidr_block        = "${cidrsubnet(signum(length(aws_vpc.my_vpc.cidr_block)) == 1 ? aws_vpc.my_vpc.cidr_block : aws_vpc.my_vpc.cidr_block, ceil(log(var.private_subnet_count * 2, 2)), count.index)}"

  availability_zone       =  "${element(data.aws_availability_zones.available.names, count.index)}"

    tags {
        Name = "private-${data.aws_availability_zones.available.names[count.index]}"
        Deployment = "${var.tag_deployment}"
        DeploymentCode = "${var.tag_deployment_code}"
        Organisation =  "${var.tag_organisation}"
        Project = "${var.tag_project}"
        KubernetesCluster = "${var.tag_kubernetes_cluster}"
    }

}

####



### Public Route Tables 
resource "aws_internet_gateway" "gw" {
  vpc_id                  = "${local.vpc_id}"
    tags {
    Deployment        = "${var.tag_deployment}"
    DeploymentCode    = "${var.tag_deployment_code}"
    KubernetesCluster = "${var.tag_kubernetes_cluster}"
    Organisation      = "${var.tag_kubernetes_cluster}"
    Project           = "${var.tag_project}"
  }

}

resource "aws_eip" "vpc_eip" {
  vpc      = true
  depends_on = ["aws_internet_gateway.gw"]
}
 resource "aws_route_table" "public" { ### Public
  vpc_id                  = "${local.vpc_id}"
    tags {
          Name = "${var.tag_project}-public"
          Deployment = "${var.tag_deployment}"
          KubernetesCluster = "${var.tag_kubernetes_cluster}"
          Organisation =  "${var.tag_organisation}"
          Project = "${var.tag_project}"
          DeploymentCode =  "${var.tag_deployment_code}"

  }
}


resource "aws_route" "public_internet_gateway" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.gw.id}"

}


resource "aws_route" "nat_gateway" {
  route_table_id         = "${aws_route_table.private.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.vpc_nat.id}"

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
  max     = "${length(var.public_subnet_count)}"
}


resource "aws_nat_gateway" "vpc_nat" {

  allocation_id = "${aws_eip.vpc_eip.id}"
  subnet_id     = "${element(aws_subnet.public.*.id, (random_integer.p_subnet_id.result))}"
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.my_vpc.id}"

  tags {
          Name = "${var.tag_project}-private"
          Deployment = "${var.tag_deployment}"
          KubernetesCluster = "${var.tag_kubernetes_cluster}"
          Organisation =  "${var.tag_organisation}"
          Project = "${var.tag_project}"
          DeploymentCode =  "${var.tag_deployment_code}"

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