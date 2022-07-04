#declaring local
locals {
  staging_env = "staging"

}



#Creating a VPC

resource "aws_vpc" "staging-vpc" {

  cidr_block = "10.5.0.0/16"
  tags = {
    Name  ="${local.staging_env}-VPC"   #Data taken from local
  }

}

#Creating a subnet

resource "aws_subnet" "staging-subnet" {
  vpc_id = aws_vpc.staging-vpc.id
  cidr_block = "10.5.0.0/16"

  tags = {


    Name  = "${local.staging_env}-subnet"  #Data taken from local
  }
}