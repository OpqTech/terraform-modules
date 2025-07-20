locals {
  environment = lookup(var.common_tags, "environment", "default")
}

resource "random_password" "dbmaster" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_ssm_parameter" "dbmaster-param" {
  name        = "/${local.environment}/database/master/password"
  description = "Aurora PostgreSQL password for ${local.environment}"
  type        = "SecureString"
  value       = random_password.dbmaster.result
  tags        = var.common_tags
}

resource "aws_ssm_parameter" "dbmaster-user" {
  name        = "/${local.environment}/database/master/username"
  description = "Aurora PostgreSQL username for ${local.environment}"
  type        = "SecureString"
  value       = "${var.rds_master_username}"
  tags        = var.common_tags
}

resource "aws_ssm_parameter" "db-name" {
  name        = "/${local.environment}/database/name"
  description = "Aurora PostgreSQL name for ${local.environment}"
  type        = "SecureString"
  value       = "${var.rds_database_name}"
  tags        = var.common_tags
}

resource "aws_db_subnet_group" "aurora_subnet_group" {
  name       = "aurora-postgres-subnet-group"
  description = "Subnet group for Aurora PostgreSQL"
  subnet_ids = data.aws_subnets.database.ids
  tags = var.common_tags
}

resource "aws_rds_cluster" "rds_cluster" {
  cluster_identifier   = "${var.rds_cluster_identifier}-${local.environment}-cluster"
  engine               = var.rds_engine
  engine_version       = var.rds_engine_version
  db_subnet_group_name = aws_db_subnet_group.aurora_subnet_group.name

  database_name   = "${var.rds_database_name}"
  master_username = "${var.rds_master_username}"
  master_password = random_password.dbmaster.result
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  kms_key_id = aws_kms_key.rds_key.arn
  storage_encrypted       = true
  backup_retention_period = var.rds_backup_retention_period
  copy_tags_to_snapshot   = true
  #skip_final_snapshot = true
  final_snapshot_identifier = "${var.rds_database_name}-${local.environment}-${formatdate("YYYYMMDD", timestamp())}"
  tags                    = var.common_tags
}

resource "aws_rds_cluster_instance" "writer_instance" {
  count      = var.rds_writer_replica_count
  identifier = "${var.rds_cluster_identifier}-${local.environment}-writer-${count.index}"
  cluster_identifier         = aws_rds_cluster.rds_cluster.id
  instance_class             = var.rds_instance_class
  engine                     = var.rds_engine
  engine_version             = var.rds_engine_version
  auto_minor_version_upgrade = var.rds_auto_minor_version_upgrade
  copy_tags_to_snapshot = true
  tags = merge(var.common_tags, { role = "writer" })
}

resource "aws_rds_cluster_instance" "reader_instances" {
  count      = var.rds_reader_replica_count
  identifier = "${var.rds_cluster_identifier}-${local.environment}-reader-${count.index}"
  cluster_identifier         = aws_rds_cluster.rds_cluster.id
  instance_class             = var.rds_instance_class
  engine                     = var.rds_engine
  engine_version             = var.rds_engine_version
  auto_minor_version_upgrade = var.rds_auto_minor_version_upgrade
  depends_on = [
    aws_rds_cluster_instance.writer_instance
  ]
  copy_tags_to_snapshot = true
  tags = merge(var.common_tags, { role = "reader" })
}

resource "aws_kms_key" "rds_key" {
  description = "RDS encryption key"
  deletion_window_in_days = 7
  enable_key_rotation = true
  tags = var.common_tags
}