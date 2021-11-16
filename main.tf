provider "aws" {
    region = var.region
}

variable "region" {
  type = string
  default = "us-west-2"
  description = "region in which ntier has to be created"
  
}

# We need to create a vpc resource
resource "aws_vpc" "awstf" {
    cidr_block = "192.168.0.0/16"
    
    enable_dns_hostnames = true
    
     tags = {
    Name = "fromtf"
  }
}

#lets create a subnet web1

resource "aws_subnet" "web1" {
  vpc_id = aws_vpc.awstf.id
  cidr_block = "192.168.0.0/24"
  availability_zone = "us-west-2a"
  
   tags = {
    Name = "web1"
  }
}

#lets create a subnet web2

resource "aws_subnet" "web2" {
  vpc_id = aws_vpc.awstf.id
  cidr_block = "192.168.1.0/24"
  availability_zone = "us-west-2b"
  
   tags = {
    Name = "web2"
  }
}
