variable "name_prefix" {
  type        = string
  description = "A prefix to add to the names of all created resources."
  default     = "tamr-config-test"
}

variable "ingress_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks from which ingress to ElasticSearch domain, Tamr VM, Tamr Postgres instance are allowed (i.e. VPN CIDR)"
  default     = []
}

variable "ami_id" {
  type        = string
  description = "AMI to use for Tamr EC2 instance"
}

variable "license_key" {
  type        = string
  description = "Tamr license key"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID of deployment"
}

variable "emr_ubnet_id" {
  type        = string
  description = "Subnet ID for ElasticSearch domain, Tamr VM, EMR cluster"
}

variable "ec2_subnet_id" {
  type        = string
  description = "Subnet ID for ElasticSearch domain, Tamr VM, EMR cluster"
}

variable "rds_subnet_group_ids" {
  type        = list(string)
  description = "List of at least 2 subnet IDs in different AZs"
}
