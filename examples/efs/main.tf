module "my_efs" {
  source = "../../efs"
  vpc_id = "vpc-AAAAA"
  subnets = ["subnet-123","subnet-1234"]
}