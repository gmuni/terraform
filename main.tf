provider "aws" {
    region = "us-west-2"
}

# We need to create a vpc resource
resource "aws_vpc" "awstf" {
    cidr_block = "192.168.0.0/16"
    
     tags = {
    Name = "fromtf"
  }
}
