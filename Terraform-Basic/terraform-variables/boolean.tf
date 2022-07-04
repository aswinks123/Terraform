resource "aws_instance" "my-instance" {
  ami = "ami-0b0ea68c435eb488d"
  instance_type = "t2.micro"
  count = 1
  associate_public_ip_address = var.enable_public_ip  #Here public IP will be added based on bool variable declared below

  tags = {

    Name  = "my-ec2-instance"
  }

}




#Crearing boolean variable for instance count

variable "enable_public_ip" {
  description = "This enable public ip for instance based on bool value"
  type = bool
  default = false
}