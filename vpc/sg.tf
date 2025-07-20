locals {
  environment = lookup(var.common_tags, "environment", "default")
}

resource "aws_security_group" "sg" {
  name = "opq-${local.environment}-sg"
  description = "opq-${local.environment}-sg"
  vpc_id = module.vpc.vpc_id 

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
    description = "to the world"
  }

  ingress {
    description = "Rule for ssh access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block, "${chomp(data.http.my_ip.body)}/32"]
  }

  ingress {
    description = "VPC access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block, "${chomp(data.http.my_ip.body)}/32"]
  }


  tags = {
    "role" = "ssh"
    "environment" = local.environment
  }
}

resource "aws_security_group" "elb-sg" {
  name = "web-to-lb-${local.environment}-sg"
  description = "  web-to-lb-${local.environment}-sg"
  vpc_id = module.vpc.vpc_id 

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
    description = "to the world"
  }

  ingress {
    description = "443 or HTTPS to lb"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "80 or HTTP to lb"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    "environment" = local.environment
  }
}
