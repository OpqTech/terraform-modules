output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "subnet_ids" {
  value = aws_subnet.subnet.id
}

output "igw_id" {
  value = aws_internet_gateway.igw.id
}

output "public_rt_id" {
  value = aws_route_table.public_rt.id
}



