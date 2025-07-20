resource "aws_security_group" "rds_sg" {
  name = "opq-${local.environment}-rds-sg"
  description = "opq-${local.environment}-vpc-rds-sg"
  vpc_id = data.aws_vpc.selected.id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
    description = ""
  }

  ingress {
    description = "Rule for VPC Link"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.selected.cidr_block]
  }
}
