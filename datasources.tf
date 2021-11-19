# datasource to fetch subnet ids
# web1 and web2
data "aws_subnet_ids" "publicsubnets" {
    vpc_id = aws_vpc.awstf.id
    filter {
      name = "tag:Name"
      values = [local.subnets[0], local.subnets[1]]
    }

}

# give me all the subnet with the tags app1, app2, db1 and db2
# data source for subnet with tags app1, app2, db1 and db2
data "aws_subnet_ids" "privatesubnets" {
    vpc_id = aws_vpc.awstf.id

    filter {
      name = "tag:Name"
      values = [local.subnets[2],local.subnets[3], local.subnets[4], local.subnets[5]]
    }
}