resource "aws_efs_file_system" "default" {
    tags = "${var.tags}"
    encrypted = "${var.encrypted}"
    performance_mode                = "${var.performance_mode}"
    provisioned_throughput_in_mibps = "${var.provisioned_throughput_in_mibps}"
    throughput_mode                 = "${var.throughput_mode}"
}

resource "aws_efs_mount_target" "default" {
  count           = "${length(var.subnets)}"
  file_system_id  = "${aws_efs_file_system.default.id}"
  subnet_id       = "${element(var.subnets, count.index)}"
  security_groups = ["${aws_security_group.default.id}"]
}

resource "aws_security_group" "default" {
  name = "${ length(var.security_group_name) > 0 ? var.security_group_name : "EFS-Security-Group" }"
  
  description = "${ length(var.description) > 0 ? var.description : "EFS" }"

  vpc_id      = "${var.vpc_id}"

  lifecycle {
    create_before_destroy = true
  }

  ingress {
    from_port       = "2049"                     # NFS
    to_port         = "2049"
    protocol        = "tcp"
    security_groups = ["${var.security_groups}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


