module "my_elasticsearch" {
    source = "../../elasticsearch/"
    domain_name           = "example"
    elasticsearch_version = "1.5"
    instance_type = "t2.micro.elasticsearch"
    snapshot_hours_period = 23
    ebs_enabled = true
    ebs_volume_size = 20
    ebs_volume_type = "gp2"
    vpc_id = "vpc-VVVVVV"
    private_subnets = ["subnet-MYSUBNET"]
    ingress_allow_cidr_blocks = ["CIDR_BLOCK"]

}