module "elasticache" {
  source = "../"
  tag_environment     = "staging"
  tag_project         = "webservices"
  availability_zones  = ["eu-west-1a", "eu-west-1b"]
  vpc_id              = "vpc-ID"
  private_subnet_list = ["subnet-ID", "subnet-ID", "subnet-ID"]
  node_type           = "cache.t2.small"

}
