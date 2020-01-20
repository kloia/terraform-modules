data "aws_ssm_parameter" "password" {
    name = "${var.password_key_ssm}"
    with_decryption = true
}

resource "aws_docdb_cluster" "docdb_cluster" {
  cluster_identifier      = "${var.cluster_name}"
  engine                  = "docdb"
  port                    = "${var.port}"
  master_username         = "${var.master_username}"
  master_password         = "${data.aws_ssm_parameter.password.value}"
  backup_retention_period = "${var.backup_retention_period}"
  skip_final_snapshot     = "${var.skip_final_snapshot}"
  apply_immediately       = "${var.apply_immediately}"
  availability_zones      = ["${var.vpc_azs}"]
  db_subnet_group_name    = "${aws_docdb_subnet_group.docdb_cluster_subnet_group.name}"
  vpc_security_group_ids  = ["${aws_security_group.docdb_cluster_sg.id}"]  

  tags = {
    Name = "${upper(var.tag_project)} DocDB Cluster"
  }
}

resource "aws_docdb_cluster_instance" "docdb_cluster_instances" {
  count              = "${var.instance_count}"

  identifier         = "docdb-cluster-instance-${count.index}"
  cluster_identifier = "${aws_docdb_cluster.docdb_cluster.id}"
  instance_class     = "${var.instance_class}"
  apply_immediately  = "${var.apply_immediately}"  

  tags = {
    Name = "${upper(var.tag_project)} DocDB Cluster Instance ${count.index}"
  }
}

resource "aws_docdb_subnet_group" "docdb_cluster_subnet_group" {
  name       = "docdb-cluster-subnet-group"
  subnet_ids = ["${var.vpc_private_subnets_ids}"]

  tags = {
    Name = "${upper(var.tag_project)} DocDB Cluster Subnet"
  }
}

resource "aws_security_group" "docdb_cluster_sg" {
  name        = "${var.tag_project}-docdb-cluster-sg"
  description = "Allow DocumentDB Port"
  vpc_id      = "${var.vpc_id}"

  ingress {
    protocol    = "TCP"
    from_port   = "${var.port}"
    to_port     = "${var.port}"    
    cidr_blocks = [
      "${var.vpc_private_subnet_cidrs}",
      "${var.vpc_public_subnet_cidrs}"  
    ]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${upper(var.tag_project)} DocDB Security Group"
  }
}

# Output
output "cluster_endpoint" {
  value = "${aws_docdb_cluster.docdb_cluster.endpoint}"
}

output "password" {
  value = "${var.password_key_ssm}"
}