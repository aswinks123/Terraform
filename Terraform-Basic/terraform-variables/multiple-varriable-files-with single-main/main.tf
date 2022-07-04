resource "aws_instance" "my-instance" {
  ami = "ami-0b0ea68c435eb488d"
  instance_type = "t2.micro"
  count = var.inst-count   #Using the data from variable declared below

  tags = {

    Name  = var.environment-type  #we have 2 files stage.tfvars and prod.tfvars that contain the value of this variable

  }

}



###Note###

#To apply this config for staging

#-> terraform plan -var-file="stage.tfvars path"

#To apply this config for production

#-> terraform plan -var-file="production.tfvars path"


