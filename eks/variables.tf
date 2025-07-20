variable "common_tags" {
  type = map(any)
}

variable "cidr_block" {
  type = string
}

variable "account_number" {
  type        = string
  description = "Target AWS account number"
}

variable "eksUser" {
  type        = string
  description = "Eks user"
}

variable "key_name" {
  type        = string
  description = "key pair name to be used"
}

variable "cluster_enabled_log_types" {
  description = "A list of the desired control plane logs to enable. For more information, see Amazon EKS Control Plane Logging documentation (https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html)"
  type        = list(string)
  
}

variable "name" {
  type        = string
  description = "Eks cluster name"
}

variable "cluster_version" {
  type        = string
  description = "EKS Cluster version"
}

