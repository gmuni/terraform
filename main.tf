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
  count = length(local.subnets)
  vpc_id = aws_vpc.awstf.id
  cidr_block = cidrsubnet(var.vpccidr,8,count.index)  # var.vpccidr in vpccidr is variable name
  #availability_zone = var.subnetazs[count.index]
  availability_zone = "${var.region}${count.index%2 == 0?"a":"b"}"
  
   tags = {
    Name = local.subnets[count.index]
  }
  
  depends_on = [
      aws_vpc.awstf  
  ]

}

resource "aws_internet_gateway" "awstfigw" {
    vpc_id = aws_vpc.awstf.id

    tags = {
      "Name" = local.igw_name
    }

    depends_on = [
      aws_vpc.awstf
    ]
  
}

#Create a route table
resource "aws_route_table" "publicrt" {
  vpc_id = aws_vpc.awstf.id

  route {
    cidr_block = local.anywhere
    gateway_id = aws_internet_gateway.awstfigw.id
  } 

    depends_on = [
     aws_vpc.awstf,
     aws_subnet.subnets[0],
     aws_subnet.subnets[1],
   ]

    tags = {
      "Name" = "publicrt"
    }
}

# Create public route table associations
resource "aws_route_table_association" "webassociations" {
  count = 2
  route_table_id = aws_route_table.publicrt.id
  subnet_id =  aws_subnet.subnets[count.index].id

  depends_on = [ 
    aws_route_table.publicrt
   ]
  
}

resource "aws_route_table" "privatert" {
  vpc_id = aws_vpc.awstf.id

   depends_on = [
     aws_vpc.awstf,
     aws_subnet.subnets[2],
     aws_subnet.subnets[3],
     aws_subnet.subnets[4],
     aws_subnet.subnets[5],
   ]

 tags = {
      "Name" = "privatert"
    }

}

# create private route table associations
resource "aws_route_table_association" "privateassociation" {

  count = 4
  route_table_id = aws_route_table.privatert.id
  subnet_id =  aws_subnet.subnets[count.index + 2].id

  depends_on = [ 
    aws_route_table.privatert
   ]

}

# create a web security group
resource "aws_security_group" "websg" {
  name = "websg"
  description = "open 22 and 80 port for all"
  vpc_id = aws_vpc.awstf.id

  ingress {
    cidr_blocks = [ local.anywhere ]
    description = "open ssh port"
    from_port = local.ssh
    protocol = local.tcp
    to_port = local.ssh
  }

  ingress {
    cidr_blocks = [ local.anywhere ]
    description = "open http port"
    from_port = local.http
    protocol = local.tcp
    to_port = local.http
  }

  tags = {
    "Name" = "websg"
  }

    depends_on = [ aws_route_table.privatert, aws_route_table.publicrt  ]
}

# Create app security group
resource "aws_security_group" "appsg" {
  name = "appsg"
  description = "open port 8080 and 22 within vpc"
  vpc_id = aws_vpc.awstf.id

  ingress {
    cidr_blocks = [ var.vpccidr ]       #this is for with vpc range
    description = "open ssh port"
    from_port = local.ssh
    protocol = local.tcp
    to_port = local.ssh
  }

  ingress {
    cidr_blocks = [ var.vpccidr ]
    description = "open app port"
    from_port = local.appport
    protocol = local.tcp
    to_port = local.appport
  }

  tags = {
    "Name" = "appsg"
  }
     depends_on = [ aws_route_table.privatert, aws_route_table.publicrt  ]
}

# Create db security group
resource "aws_security_group" "dbsg" {
  name = "dbsg"
  description = "open port 3306 within vpc"
  vpc_id = aws_vpc.awstf.id

  ingress {
    cidr_blocks = [ var.vpccidr ]
    description = "open app port"
    from_port = local.dbport
    protocol = local.tcp
    to_port = local.dbport
  }

  tags = {
    "Name" = "dbsg"
  }

  depends_on = [ aws_route_table.privatert, aws_route_table.publicrt  ]
  
}