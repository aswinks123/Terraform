#--------------- Creating a VPC------------------------------------------------------<aws ec2 describe-vpcs>

resource "aws_vpc" "aswin-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "aswin-vpc"
  }
}


#--------------Creating a subnet in that VPC--------------------------------------------<aws ec2 describe-subnets>
resource "aws_subnet" "subnet-1" {
   vpc_id            = aws_vpc.aswin-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
   tags = {
     Name = "aswin-subnet"
 }
 }

 #------------Create an Internet Gateway and attach to VPC-------------------------  <aws ec2 describe-internet-gateways>

resource "aws_internet_gateway" "aswin-ig" {
  vpc_id = aws_vpc.aswin-vpc.id
 tags = {
    Name = "aswin-ig"
  } 
}

#------------Create a Custom Route tables for VPC---------------------------------- <aws ec2 describe-route-tables>

resource "aws_route_table" "aswin-route-table" {
vpc_id = aws_vpc.aswin-vpc.id

route {
cidr_block = "0.0.0.0/0"
gateway_id = aws_internet_gateway.aswin-ig.id
}

route {
 ipv6_cidr_block = "::/0"
 gateway_id      = aws_internet_gateway.aswin-ig.id
  }

  tags = {
    Name = "aswin-route-table"
  }
}

#---------Associate the route table to a subnet-------------------------------------- <aws ec2 describe-subnets>
resource "aws_route_table_association" "association" {
	subnet_id      = aws_subnet.subnet-1.id
	route_table_id = aws_route_table.aswin-route-table.id
}

#-----------Creating a Security group that allow port 22-------------------------------- < aws ec2 describe-security-groups>

resource "aws_security_group" "allow_web" {
   name        = "allow_web_traffic"
   description = "Allow Web inbound traffic"
   vpc_id      = aws_vpc.aswin-vpc.id

   ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
  }
   tags = {
    Name = "allow_web"
 }
 }

 #---------Create a NW-interface with IP in the subnet and attach the SG to it---------------<aws ec2 describe-network-interfaces>

 resource "aws_network_interface" "aswin-nic" {
   subnet_id       = aws_subnet.subnet-1.id
   private_ips     = ["10.0.1.50"]
   security_groups = [aws_security_group.allow_web.id]
   tags = {
    Name = "aswin-nic"
 }
}

#---------Create an Elastic IP for the interface that we created before------------------------

 resource "aws_eip" "one" {
   vpc                       = true
   network_interface         = aws_network_interface.aswin-nic.id
   associate_with_private_ip = "10.0.1.50"
   depends_on                = [aws_internet_gateway.aswin-ig]
   }



 #----------Creating an instance-------------------------

 resource "aws_instance" "aswin-server" {
   ami               = "ami-173d747e"
   instance_type     = "t2.micro"
   availability_zone = "us-east-1a"
  

   network_interface {
     device_index         = 0
     network_interface_id = aws_network_interface.aswin-nic.id
 }
     tags = {
     Name = "aswin-server"
  }
 
}

