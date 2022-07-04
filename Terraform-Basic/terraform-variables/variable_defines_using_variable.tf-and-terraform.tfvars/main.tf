resource "aws_instance" "my-instance" {
  ami = "ami-0b0ea68c435eb488d"
  instance_type = "t2.micro"
  count = var.inst-count   #Using the data from variable declared below

  tags = {

    Name  = "my-ec2-instance"
  }

}

