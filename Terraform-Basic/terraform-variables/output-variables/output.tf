#declaring local
locals {
  staging_env = "staging"

}



#Creating a VPC

resource "aws_vpc" "staging-vpc" {

  cidr_block = "10.5.0.0/16"
  tags = {
    Name  ="${local.staging_env}-VPC"
  }

}

#Creating a subnet

resource "aws_subnet" "staging-subnet" {
  vpc_id = aws_vpc.staging-vpc.id
  cidr_block = "10.5.0.0/16"

  tags = {


    Name  = "${local.staging_env}-subnet"

  }
}

#Creating an output variable to output the VPC arn and Subnet CIDR to console
output "my_output" {
  #value = "VPC and Subnet Created"
  value = ["VPC ARN is ${aws_vpc.staging-vpc.arn}","Subnet CIDR is : ${aws_subnet.staging-subnet.cidr_block}"]

}