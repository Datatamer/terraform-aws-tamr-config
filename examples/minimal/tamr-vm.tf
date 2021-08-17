module "tamr-vm" {
  source = "git::git@github.com:Datatamer/terraform-emr-tamr-vm?ref=1.0.2"

  ami                 = data.aws_ami.tamr-vm.id
  instance_type       = "r5.2xlarge"
  key_name            = module.emr_key_pair.key_pair_key_name
  subnet_id           = var.ec2_subnet_id
  vpc_id              = var.vpc_id
  sg_name             = "${var.name_prefix}-tamrvm-sg"
  ingress_cidr_blocks = var.ingress_cidr_blocks
  egress_cidr_blocks  = ["0.0.0.0/0"] # TODO: scope down
  availability_zone = data.aws_subnet.application_subnet.availability_zone
  aws_role_name               = "${var.name_prefix}-tamr-ec2-role"
  aws_instance_profile_name   = "${var.name_prefix}-tamrvm-instance-profile"
  aws_emr_creator_policy_name = "${var.name_prefix}-emr-creator-policy"
  s3_policy_arns = [
    module.s3-logs.rw_policy_arn,
    module.s3-data.rw_policy_arn
  ]
}

data "aws_ami" "tamr-vm" {
  most_recent = true
  owners      = ["679593333241"]
  name_regex  = "^Ubuntu 18.04 Tamr.*"
  filter {
    name   = "product-code"
    values = ["832nkbrayw00cnivlh6nbbi6p"]
  }
}
