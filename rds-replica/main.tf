module "global"  {
  source = "../globalvariable"
  tag_name = "${var.tag_name}"
  tag_deployment = "${var.tag_deployment}"
  tag_kubernetes_cluster = "${var.tag_kubernetes_cluster}"
  tag_organisation =  "${var.tag_organisation}"
  tag_project = "${var.tag_project}"
  tag_deployment_code =  "${var.tag_deployment_code}"

}

resource "aws_db_instance" "my_db_replica" {
    count = "${var.enabled == "true" ? 1 : 0}"
    name  = "${var.database_name}"
    replicate_source_db = "${var.source_db_name}"
    username = "${var.database_user}"
    password = "${var.database_password}"
    engine_version = "${var.engine_version}"
    instance_class = "${var.instance_class}"
    allocated_storage  = "${var.allocated_storage}"
    storage_encrypted  = "${var.storage_encrypted}"
    vpc_security_group_ids  = ["${aws_security_group.default.id}"]
    db_subnet_group_name = "${aws_db_subnet_group.default.name}"
}

resource "aws_db_subnet_group" "default" {
  count      = "${var.enabled == "true" ? 1 : 0}"
  name       = "${var.subnet_group_name}"### label group problem!
  subnet_ids = ["${var.subnet_ids}"]
}

resource "aws_db_option_group" "opt_group" {
  
  name                     ="optiongroup"

  option_group_description = "${var.option_group_description}"
  engine_name              = "${var.engine}"
  major_engine_version     = "${var.major_engine_version}"
  
  option = ["${var.options}"]

}

resource "aws_security_group" "default" {

    vpc_id = "${var.vpc_id}"

    ingress {
        from_port = "${lookup(var.port, var.engine)}"
        to_port = "${lookup(var.port, var.engine)}"
        protocol = "tcp"
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

}