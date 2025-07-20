data "aws_vpc" "selected" {
  filter {
    name   = "tag:environment"
    values = ["dev"]
  }
}

data "aws_subnets" "database" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
  filter {
    name   = "tag:Tier"
    values = ["Database"]
  }
}

