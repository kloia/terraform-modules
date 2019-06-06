module "my_vpc" {
    source = "../../vpc"
    public_subnet_count = 3
    private_subnet_count     =  3
}

output "private_subnet_cidrs" {
  value = "${module.my_vpc.private_subnet_cidrs}"
}

output "public_subnet_cidrs" {
  value = "${module.my_vpc.public_subnet_cidrs}"
}
