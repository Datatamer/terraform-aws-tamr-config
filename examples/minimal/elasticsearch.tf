module "tamr-es-cluster" {
  source = "git::git@github.com:Datatamer/terraform-aws-es?ref=1.0.1"

  # Names
  domain_name = "${var.name_prefix}-es-domain"
  sg_name     = "${var.name_prefix}-es-security-group"

  # Only needed once per account, set to true if first time running in account
  create_new_service_role = false

  # In-transit encryption options
  node_to_node_encryption_enabled = true
  enforce_https                   = true

  # Networking
  vpc_id     = var.vpc_id
  subnet_ids = data.aws_subnet.application_subnet.availability_zone == data.aws_subnet.data_subnet_0.availability_zone ? [var.data_subnet_ids[0]] : [var.data_subnet_ids[1]]
  security_group_ids = [
    // Spark
    module.emr.emr_service_access_sg_id,
    module.emr.emr_managed_master_sg_id,
    module.emr.emr_additional_master_sg_id,
    module.emr.emr_managed_core_sg_id,
    module.emr.emr_additional_core_sg_id,
    //  VM
    module.tamr-vm.tamr_security_groups["tamr_security_group_id"]
  ]
  # CIDR blocks to allow ingress from (i.e. VPN)
  ingress_cidr_blocks = var.ingress_cidr_blocks
}

# To avoid cross-az traffic we place the ES cluster in the same AZ as the application subnet
data "aws_subnet" "application_subnet" {
  id = var.ec2_subnet_id
}

data "aws_subnet" "data_subnet_0" {
  id = var.data_subnet_ids[0]
}
