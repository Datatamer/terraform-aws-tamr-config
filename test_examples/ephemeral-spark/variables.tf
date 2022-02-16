variable "name_prefix" {
  type        = string
  description = "A prefix to add to the names of all created resources."
}

variable "ingress_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks from which ingress to ElasticSearch domain, Tamr VM, Tamr Postgres instance are allowed (i.e. VPN CIDR)"
  default     = ["0.0.0.0/0"]
}

variable "egress_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks from which ingress to ElasticSearch domain, Tamr VM, Tamr Postgres instance are allowed (i.e. VPN CIDR)"
  default     = ["0.0.0.0/0"]
}

variable "license_key" {
  type        = string
  description = "Tamr license key"
}

variable "tags" {
  type        = map(string)
  description = "Map of tags to add to resources."
  default     = {}
}

variable "emr_tags" {
  type        = map(string)
  description = "Map of tags to add to EMR resources. They must contain abac_valid_tags at minimum"
  default     = {}
}

variable "emr_abac_valid_tags" {
  type        = map(list(string))
  description = "Valid tags for maintaining resources when using ABAC IAM Policies with Tag Conditions. Make sure `emr_tags` contain the values specified here and that your Subnet is tagged as well"
  default     = {}
}

variable "ami_id" {
  type        = string
  description = "AMI to use for Tamr EC2 instance"
  default     = ""
}
