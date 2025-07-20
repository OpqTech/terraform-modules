//CIDR block for VPC creation
cidr_block = "10.0.0.0/22"

//common tags used across all the resources
common_tags = {
  "environment" = "dev"
  "ticket" = "devops-1010"
  "application" = "opq"
  "createdby" = "devops@opqtech.com"
}

//EKS details
key_name = "opq"
cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
eksUser = "opq"
name = "opq"
cluster_version = "1.32"
account_number = "891543987898"