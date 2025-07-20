module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"
  name = "${var.common_tags["application"]}-${var.common_tags["environment"]}-vpc"
  cidr = var.cidr_block

  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false
  create_database_subnet_group = true  

  #azs = [data.aws_availability_zones.az.names[0], data.aws_availability_zones.az.names[1]]
  azs = local.azs
  public_subnets = local.public_subnets
  database_subnets = local.database_subnets
  private_subnets = local.private_subnets

  public_subnet_tags = local.public_subnet_tags
  database_subnet_tags = local.database_subnet_tags
  private_subnet_tags = local.private_subnet_tags

  public_route_table_tags = local.public_route_table_tags
  database_route_table_tags = local.database_route_table_tags
  private_route_table_tags = local.private_route_table_tags

  tags = merge(var.common_tags, var.vpc_tags)
}

resource "aws_iam_role" "cw_log_role" {
  name = "${var.common_tags["application"]}-${var.common_tags["environment"]}-vpc-log"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid = ""  
      Effect = "Allow"
      Principal = {
        Service = "vpc-flow-logs.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "vpc_flow_logs_policy" {
  name        = "VPCFlowLogsPolicy"
  role = aws_iam_role.cw_log_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ]
      Resource = "*"
    }]
  })
}
