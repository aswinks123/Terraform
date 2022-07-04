#To Demonstrate Dynamic Block


#Creating a local for storing the port and description.
locals {
    ingress_rule = [
      {
        port        = 22
        description = "for SSH"
      },
      {
        port        = 443
        description = "for https"
      }

    ]
  }


#Creating a VPC for testing

resource "aws_vpc" "aswin-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "aswin-vpc"
  }
}




#Creating a Security group.

resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow Web inbound traffic"
  vpc_id      = aws_vpc.aswin-vpc.id


  #Dynamic block to fetch data from local created above to map the port.

  dynamic "ingress" {
    for_each = local.ingress_rule  #ingress_rule is the local name created above
    content {
      description = ingress.value.description  #fetch data from locals
      from_port   = ingress.value.port          #fetch data from locals
      to_port     = ingress.value.port          #fetch data from locals
      protocol    = "tcp"
      cidr_blocks  = ["0.0.0.0/0"]
    }
  }
}