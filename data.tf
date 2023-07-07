data "aws_vpc" "default_vpc" {
  filter {
    name   = "tag:Name"
    values = ["default_vpc"]
  }
}

data "aws_route_table" "route_table" {
    filter {
        name = "tag:Name"
        values = ["route_table"]
    }
}