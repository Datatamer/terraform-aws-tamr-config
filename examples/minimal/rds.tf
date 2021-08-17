# Generate random password for db
resource "random_password" "rds-password" {
  length  = 16
  special = false
}

module "rds-postgres" {
  source = "git::git@github.com:Datatamer/terraform-aws-rds-postgres.git?ref=1.0.0"

  identifier_prefix = "${var.name_prefix}-"
  username          = "tamr"
  password          = random_password.rds-password.result

  subnet_group_name    = "${var.name_prefix}-subnet-group"
  postgres_name        = "tamr0"
  parameter_group_name = "${var.name_prefix}-rds-postgres-pg"
  security_group_name  = "${var.name_prefix}-sg"

  vpc_id = var.vpc_id
  # Network requirement: DB subnet group needs a subnet in at least two AZs
  rds_subnet_ids = var.data_subnet_ids

  ingress_sg_ids = [
    module.emr.emr_service_access_sg_id,
    module.emr.emr_managed_master_sg_id,
    module.emr.emr_additional_master_sg_id,
    module.emr.emr_managed_core_sg_id,
    module.emr.emr_additional_core_sg_id,
    module.tamr-vm.tamr_security_groups["tamr_security_group_id"]
  ]
  additional_cidrs = var.ingress_cidr_blocks
}
