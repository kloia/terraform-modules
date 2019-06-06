resource "aws_iam_service_linked_role" "es" {
  aws_service_name = "es.amazonaws.com"
}### requirement for creating elasticsearch 

resource "aws_security_group" "elasticsearch" {
  description = "Security Group to allow traffic to ElasticSearch"

  vpc_id = "${var.vpc_id}"
}

data "aws_subnet" "private_subnet" {
 id  = "${element(var.private_subnets,0)}"
}

resource "aws_security_group_rule" "secure_cidrs" {
  count = "${length(var.ingress_allow_cidr_blocks) > 0 ? 1 : 0}"

  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "TCP"
  cidr_blocks = ["${split(",", length(var.ingress_allow_cidr_blocks) > 0 ? join(",", var.ingress_allow_cidr_blocks)  : data.aws_subnet.private_subnet.cidr_block )}"]

  security_group_id = "${aws_security_group.elasticsearch.id}"
}

resource "aws_security_group_rule" "egress_all" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.elasticsearch.id}"
}


resource "aws_elasticsearch_domain" "es" {
  domain_name           = "${var.domain_name}"
  elasticsearch_version = "${var.elasticsearch_version}"

  cluster_config {
    instance_type            = "${var.instance_type}"
    instance_count           = "${var.instance_count}"
    dedicated_master_enabled = "${var.instance_count >= 10 ? true : false}"
    dedicated_master_count   = "${var.instance_count >= 10 ? 3 : 0}"
    dedicated_master_type    = "${var.instance_count >= 10 ? (var.dedicated_master_type != "false" ? var.dedicated_master_type : var.instance_type) : ""}"
    zone_awareness_enabled   = "${var.es_zone_awareness}"

  }

  snapshot_options {
    automated_snapshot_start_hour = "${var.snapshot_hours_period}"
  }

  tags = {
    Domain = "${var.domain_name}"
  }


  vpc_options {
    security_group_ids = ["${aws_security_group.elasticsearch.id}"]
    subnet_ids         = ["${element(var.private_subnets,0)}"]
  }


   ebs_options{
    ebs_enabled = "${var.ebs_enabled}"
    volume_size = "${var.ebs_volume_size}"
    volume_type = "${var.ebs_volume_type}"

   }
}

module "elastic_search_route53_record" {
  source = "../route53"
  type    = "CNAME"
  ttl     = "300"
  domain    = "${var.domain_name}"
  name = "alb.${var.domain_name}"
  records = "${aws_elasticsearch_domain.es.endpoint}"
}
