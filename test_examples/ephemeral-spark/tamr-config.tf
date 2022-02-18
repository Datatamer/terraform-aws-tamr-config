module "examples_ephemeral_spark" {
  #   source = "git::git@github.com:Datatamer/terraform-aws-tamr-config?ref=2.0.0"
  source = "../../examples/ephemeral-spark"

  name_prefix           = var.name_prefix
  ingress_cidr_blocks   = var.ingress_cidr_blocks
  egress_cidr_blocks    = var.egress_cidr_blocks
  license_key           = var.license_key
  ami_id                = var.ami_id
  vpc_id                = module.vpc.vpc_id # var.vpc_id
  tags                  = var.tags
  emr_tags              = var.emr_tags
  emr_abac_valid_tags   = var.emr_abac_valid_tags
  compute_subnet_id     = module.vpc.compute_subnet_id
  data_subnet_ids       = module.vpc.data_subnet_ids
  application_subnet_id = module.vpc.application_subnet_id
}

module "vpc" {
  source = "git::https://github.com/Datatamer/terraform-aws-networking.git?ref=0.1.0"

  ingress_cidr_blocks           = var.ingress_cidr_blocks
  vpc_cidr_block                = "172.40.0.0/20"
  data_subnet_cidr_blocks       = ["172.40.2.0/24", "172.40.3.0/24"]
  application_subnet_cidr_block = "172.40.4.0/24"
  compute_subnet_cidr_block     = "172.40.5.0/24"
  availability_zones            = [for i in ["a", "b"] : "${data.aws_region.current.name}${i}"]
  create_public_subnets         = false
  create_load_balancing_subnets = false
  enable_nat_gateway            = false
  tags = {
    "Name" : "tamr-vpc-minimal"
    "application" : "tamr",
    "Terraform" : "true"
  }
}

data "aws_region" "current" {}
