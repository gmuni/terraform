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
  cidr_block = var.cidrranges[count.index]
  availability_zone = var.subnetazs[count.index]
  
   tags = {
    Name = var.subnets[count.index]
  }
}


