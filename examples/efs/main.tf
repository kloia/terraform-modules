module "my_efs" {
  source = "../../efs"
  vpc_id = "vpc-07e0a91d478ba30f9"
  subnets = ["subnet-05e39d564af58d6bf","subnet-05b6c3c18247542b3"]
}

