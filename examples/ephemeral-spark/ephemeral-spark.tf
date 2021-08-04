# Ephemeral Spark cluster
module "ephemeral-spark-sgs" {
  source              = "git::git@github.com:Datatamer/terraform-aws-emr.git//modules/aws-emr-sgs?ref=6.0.0"
  vpc_id              = var.vpc_id
  emr_managed_sg_name = format("%s-%s", var.name_prefix, "Ephem-Spark-Internal")
  tags                = merge(var.tags, var.emr_tags)
}

module "ephemeral-spark-iam" {
  source                            = "git::git@github.com:Datatamer/terraform-aws-emr.git//modules/aws-emr-iam?ref=6.0.0"
  s3_bucket_name_for_logs           = module.s3-logs.bucket_name
  s3_bucket_name_for_root_directory = module.s3-data.bucket_name
  s3_policy_arns = [
    module.s3-logs.rw_policy_arn,
    module.s3-data.rw_policy_arn
  ]
  emr_ec2_iam_policy_name       = "${var.name_prefix}-spark-ec2-policy"
  emr_service_iam_policy_name   = "${var.name_prefix}-spark-service-policy"
  emr_service_role_name         = "${var.name_prefix}-spark-service-role"
  emr_ec2_instance_profile_name = "${var.name_prefix}-spark-emr-instance-profile"
  emr_ec2_role_name             = "${var.name_prefix}-spark-ec2-role"
  tags                          = var.tags
}

module "ephemeral-spark-config" {
  source                         = "git::git@github.com:Datatamer/terraform-aws-emr.git//modules/aws-emr-config?ref=6.0.0"
  create_static_cluster          = false
  cluster_name                   = "" # unused
  emr_config_file_path           = "./emr.json"
  bucket_name_for_root_directory = module.s3-data.bucket_name
}
