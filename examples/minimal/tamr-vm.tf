module "tamr-vm" {
  source = "git::git@github.com:Datatamer/terraform-emr-tamr-vm?ref=1.0.2"

  ami                 = var.ami_id
  instance_type       = "m4.2xlarge"
  key_name            = module.emr_key_pair.key_pair_key_name
  subnet_id           = var.ec2_subnet_id
  vpc_id              = var.vpc_id
  sg_name             = "${var.name_prefix}-tamrvm-sg"
  ingress_cidr_blocks = var.ingress_cidr_blocks
  egress_cidr_blocks  = ["0.0.0.0/0"] # TODO: scope down

  aws_role_name               = "${var.name_prefix}-tamr-ec2-role"
  aws_instance_profile_name   = "${var.name_prefix}-tamrvm-instance-profile"
  aws_emr_creator_policy_name = "${var.name_prefix}-emr-creator-policy"
  s3_policy_arns = [
    module.s3-logs.rw_policy_arn,
    module.s3-data.rw_policy_arn
  ]
}
