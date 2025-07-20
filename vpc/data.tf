data "aws_availability_zones" "az" {
  state = "available"
}

data "aws_region" "current" {}

data "http" "my_ip" {
  url = "https://ifconfig.me/ip"
}
