locals {
    azs = formatlist("${data.aws_region.current.name}%s", ["a", "b"])
    subnets = cidrsubnets(var.cidr_block, 3, 3, 3, 3, 2, 2)
    public_subnets = [local.subnets[0], local.subnets[1]]
    database_subnets = [local.subnets[2], local.subnets[3]]
    private_subnets = [local.subnets[4], local.subnets[5]]

    private_subnet_tags = merge(var.common_tags, { Name = "${var.common_tags["application"]}-${var.common_tags["environment"]}-private-subnet" }, { Tier = "Private" })
    database_subnet_tags = merge(var.common_tags, { Name = "${var.common_tags["application"]}-${var.common_tags["environment"]}-database-subnet" }, { Tier = "Database" })
    public_subnet_tags = merge(var.common_tags, { Name = "${var.common_tags["application"]}-${var.common_tags["environment"]}-public-subnet" }, { Tier = "Public" })


    private_route_table_tags = merge(var.common_tags, { Name = "${var.common_tags["application"]}-${var.common_tags["environment"]}-private-rt" }, { Tier = "Private" })
    database_route_table_tags = merge(var.common_tags, { Name = "${var.common_tags["application"]}-${var.common_tags["environment"]}-database-rt" }, { Tier = "Database" })
    public_route_table_tags = merge(var.common_tags, { Name = "${var.common_tags["application"]}-${var.common_tags["environment"]}-public-rt" }, { Tier = "Public" })
}