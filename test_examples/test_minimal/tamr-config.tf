module "tamr-config" {
  #   source = "git::git@github.com:Datatamer/terraform-aws-tamr-config?ref=2.0.0"
  source = "../.."

  config_template_path       = "../../tamr-config.yml"
  rendered_config_path       = "./rendered-config.yml"
  ephemeral_spark_configured = false
  additional_templated_variables = {
    "TAMR_LICENSE_KEY" : "TAMR_LICENSE_KEY_VALUE"
  }

  rds_pg_hostname = "rds_pg_hostname" // module.rds-postgres.rds_hostname
  rds_pg_dbname   = "rds_pg_dbname"   // module.rds-postgres.rds_dbname
  rds_pg_username = "rds_pg_username" // module.rds-postgres.rds_username
  rds_pg_password = random_password.rds-password.result
  rds_pg_db_port  = 123 // module.rds-postgres.rds_db_port

  hbase_namespace   = "tamr"
  tamr_data_bucket  = "tamr_data_bucket"  // module.s3-data.bucket_name
  hbase_config_path = "hbase_config_path" // module.emr.hbase_config_path

  spark_emr_cluster_id           = "spark_emr_cluster_id"  // module.emr.tamr_emr_cluster_id
  spark_cluster_log_uri          = "spark_cluster_log_uri" // module.emr.log_uri
  tamr_data_path                 = "tamr/unify-data"
  tamr_spark_config_override     = "[{'name' : 'sparkOverride1','executorInstances' : '2','sparkProps' : {'spark.cores.max' : '4'}},{'name' : 'sparkOverride2','driverMemory' : '4G','executorMemory' : '5G'}]"
  tamr_spark_properties_override = "{'spark.driver.maxResultSize':'4g'}"
  es_domain_endpoint             = "es_domain_endpoint" // module.tamr-es-cluster.tamr_es_domain_endpoint

  tamr_external_storage_providers = "[{'name' : 's3a_tamr_config_test','description' : 'The S3a filesystem at root of s3-data-bucket-name','uri' : 's3a://s3-data-bucket-name/'}]" // "[{'name' : 's3a_tamr_config_test','description' : 'The S3a filesystem at root of ${module.s3-data.bucket_name}','uri' : 's3a://${module.s3-data.bucket_name}/'}]"

  # Backup
  tamr_backup_emr_cluster_id = "tamr_backup_emr_cluster_id" // module.emr.tamr_emr_cluster_id
}

resource "random_password" "rds-password" {
  length  = 16
  special = false
}