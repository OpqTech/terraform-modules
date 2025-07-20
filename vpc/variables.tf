variable "common_tags" {
  type = map(any)
}

variable "cidr_block" {
  type = string
}

variable "vpc_tags" {
  type = map(any)
  default = {
    "module" = "https://github.com/terraform-aws-modules/terraform-aws-vpc"
  }
}