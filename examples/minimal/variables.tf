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

variable "license_key" {
  type        = string
  description = "Tamr license key"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID of deployment"
}

variable "emr_subnet_id" {
  type        = string
  description = "Subnet ID for EMR cluster"
}

variable "ec2_subnet_id" {
  type        = string
  description = "Subnet ID for Tamr VM"
}

variable "data_subnet_ids" {
  type        = list(string)
  description = "List of at least 2 subnet IDs in different AZs"
}
