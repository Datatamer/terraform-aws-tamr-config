data "aws_region" "current" {}

data "aws_ami" "tamr-vm" {
  most_recent = true
  owners      = ["679593333241"]
  name_regex  = "^Ubuntu 18.04 Tamr.*"
  filter {
    name   = "product-code"
    values = ["832nkbrayw00cnivlh6nbbi6p"]
  }
}

module "examples_complete" {
  #   source = "git::git@github.com:Datatamer/terraform-aws-tamr-config?ref=2.0.0"
  source = "../../examples/complete"

  name_prefix                        = var.name_prefix
  ingress_cidr_blocks                = var.ingress_cidr_blocks
  egress_cidr_blocks                 = var.egress_cidr_blocks
  license_key                        = var.license_key
  ami_id                             = data.aws_ami.tamr-vm.id # var.ami_id
  vpc_cidr_block                     = var.vpc_cidr_block      # var.vpc_id
  tags                               = var.tags
  emr_tags                           = var.emr_tags
  emr_abac_valid_tags                = var.emr_abac_valid_tags
  compute_subnet_cidr_block          = var.compute_subnet_cidr_block
  data_subnet_cidr_blocks            = var.data_subnet_cidr_blocks
  application_subnet_cidr_block      = var.application_subnet_cidr_block
  load_balancing_subnets_cidr_blocks = var.load_balancing_subnets_cidr_blocks
  public_subnets_cidr_blocks         = var.public_subnets_cidr_blocks
  create_new_service_role            = false
}

# data "aws_region" "current" {}

# data "aws_ami" "tamr-vm" {
#   most_recent = true
#   owners      = ["679593333241"]
#   name_regex  = "^Ubuntu 18.04 Tamr.*"
#   filter {
#     name   = "product-code"
#     values = ["832nkbrayw00cnivlh6nbbi6p"]
#   }
# }
