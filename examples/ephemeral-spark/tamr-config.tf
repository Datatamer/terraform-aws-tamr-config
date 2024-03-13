module "tamr-config" {
  #   source = "git::git@github.com:Datatamer/terraform-aws-tamr-config?ref=2.4.5"
  source = "../.."

  config_template_path       = "tamr-config.yml.tmpl"
  rendered_config_path       = "./rendered-config.yml"
  ephemeral_spark_configured = true
  additional_templated_variables = {
    "TAMR_LICENSE_KEY" : var.license_key
  }
  emr_tags = var.emr_tags

  # Backup
  tamr_backup_emr_cluster_id = module.emr-hbase.tamr_emr_cluster_id

  # RDS
  rds_pg_hostname = module.rds-postgres.rds_hostname
  rds_pg_dbname   = module.rds-postgres.rds_dbname
  rds_pg_username = module.rds-postgres.rds_username
  rds_pg_password = random_password.rds-password.result
  rds_pg_db_port  = module.rds-postgres.rds_db_port

  # HBase
  hbase_namespace   = "tamr"
  tamr_data_bucket  = module.s3-data.bucket_name
  hbase_config_path = module.emr-hbase.hbase_config_path

  # ElasticSearch
  es_domain_endpoint = module.tamr-opensearch-cluster.tamr_es_domain_endpoint

  # Spark
  spark_emr_cluster_id           = ""
  spark_cluster_log_uri          = "s3n://${module.s3-logs.bucket_name}/${var.path_to_spark_logs}"
  spark_driver_memory            = "10G"
  spark_executor_instances       = 7
  spark_executor_memory          = "12G"
  spark_executor_cores           = 2
  tamr_data_path                 = "tamr/unify-data"
  tamr_spark_properties_override = "{'spark.driver.maxResultSize':'4g'}"

  # Ephemeral Spark
  emr_release_label         = "emr-5.29.0" # spark 2.4.4
  emr_instance_profile_name = module.ephemeral-spark-iam.emr_ec2_instance_profile_name
  emr_service_role_name     = module.ephemeral-spark-iam.emr_service_role_name
  emr_key_pair_name         = module.emr_key_pair.key_pair_key_name
  emr_subnet_id             = var.compute_subnet_id
  master_instance_type      = "m4.large"
  master_ebs_volumes_count  = 1
  master_ebs_size           = 50
  master_ebs_type           = "gp2"
  core_ebs_volumes_count    = 1
  core_ebs_size             = 200
  core_ebs_type             = "gp2"
  core_group_instance_count = 4
  core_instance_type        = "r5.xlarge"

  emr_managed_master_sg_id = module.ephemeral-spark-sgs.emr_managed_sg_id
  # emr_managed_master_sg_id = "" # you may leave this blank and AWS creates one automatically
  emr_additional_master_sg_id = join(",", module.aws-emr-sg-core.security_group_ids)
  emr_managed_core_sg_id      = module.ephemeral-spark-sgs.emr_managed_sg_id
  # emr_managed_core_sg_id   = "" # you may leave this blank and AWS creates one automatically
  emr_additional_core_sg_id = join(",", module.aws-emr-sg-master.security_group_ids)
  emr_service_access_sg_id  = module.aws-emr-sg-service-access.security_group_ids[0]

  # Data Movement
  apps_dms_enabled = false
}

# Upload the Tamr configuration to S3
resource "aws_s3_bucket_object" "upload_tamr_config" {
  bucket                 = module.s3-data.bucket_name
  key                    = "tamr/tamr-config.yml"
  content                = module.tamr-config.tamr_config_file
  server_side_encryption = "AES256"
}
