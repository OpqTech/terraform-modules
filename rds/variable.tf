variable "common_tags" {
  type        = map(string)
  description = "A tagging scheme"
}

# variable "environment" {
#   description = "environment"
#   type        = string
# }

variable "rds_database_name" {
  type        = string
  description = "Name of the Aurora PostgreSQL DB"
  default     = "opq"
}

variable "rds_cluster_identifier" {
  type    = string
  default = "opq"
}

variable "rds_engine" {
  type    = string
  default = "aurora-postgresql"
}

variable "rds_engine_version" {
  type        = string
  description = "Engine Version"
  default     = "16.6"
}

variable "rds_db_subnet_group_name" {
  type        = string
  description = "Name of the Aurora PostgrSQL DB subnet Group"
  default = "opq PostgrSQL DB subnet Group"
}

variable "rds_backup_retention_period" {
  description = "cluster backup retention period"
  type        = number
  default     = 7
}

variable "rds_instance_class" {
  type        = string
  description = "Aurora PostgreSQL DB Instance class"
  default     = "db.t3.medium"
}

variable "rds_writer_replica_count" {
  type        = number
  description = "Number of writer replica in the cluster"
  default     = 1
}

variable "rds_reader_replica_count" {
  type        = number
  description = "Number of read replica in the cluster"
  default     = 1
}

variable "rds_auto_minor_version_upgrade" {
  description = "auto minor upgrade option"
  type        = bool
  default     = false
}

variable "rds_master_username" {
  type    = string
  default = "postgres"
}