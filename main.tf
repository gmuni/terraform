# We need to create a vpc resource
resource "aws_vpc" "awstf" {
    cidr_block = var.vpccidr
    
    enable_dns_hostnames = true
    
     tags = {
    Name = "fromtf"
  }
}

#lets create a all subnets

resource "aws_subnet" "subnets" {
  count = 6
  vpc_id = aws_vpc.awstf.id
  cidr_block = cidrsubnet(var.vpccidr,8,count.index)  # var.vpccidr in vpccidr is variable name
  #availability_zone = var.subnetazs[count.index]
  availability_zone = "${var.region}${count.index%2 == 0?"a":"b"}"
  
   tags = {
    Name = local.subnets[count.index]
  }
}


