resource "aws_instance" "webserver1" {
    ami = "ami-036d46416a34a611c"
    associate_public_ip_address = true
    instance_type = "t2.micro"
    key_name = "terraform"
    vpc_security_group_ids = [ aws_security_group.websg.id ]
    subnet_id = aws_subnet.subnets[0].id
    tags = {
      "Name" = "webserver 1"
    }

    depends_on = [ aws_db_instance.ntierdb ]
    
}