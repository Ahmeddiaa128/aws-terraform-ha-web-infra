# Public subnets
resource "aws_subnet" "public" {
    for_each = var.public_subnets

    vpc_id = var.vpc_id
    cidr_block = each.value.cidr_block
    availability_zone = each.value.availability_zone
    map_public_ip_on_launch = true

    tags = {
    Name = each.key
  }
}


# Private subnets
resource "aws_subnet" "private" {
    for_each = var.private_subnets

    vpc_id = var.vpc_id
    cidr_block = each.value.cidr_block
    availability_zone = each.value.availability_zone
    map_public_ip_on_launch = false

    tags = {
    Name = each.key
  }
}

