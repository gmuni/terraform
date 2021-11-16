provider "aws" {
    region = "us-west-2"
}

# We need to create a vpc resource
resource "aws_vpc" "awstf" {
    cidr_block = "192.168.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true
    
     tags = {
    Name = "fromtf"
  }
}

#lets create a subnet

resource "aws_subnet" "web1" {
  vpc_id = aws_vpc.awstf.id
  cidr_block = "192.168.0.0/24"
  availability_zone = "us-west-2a"
  
   tags = {
    Name = "web1"
  }
}
