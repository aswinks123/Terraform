resource "aws_instance" "my-instance" {
  ami = "ami-0b0ea68c435eb488d"
  instance_type = "t2.micro"
  count = var.inst-count   #Using the data from variable declared in variable.tf file


}





#To supply variable from terminal 

# -> terraform plan -var="inst-count"=2  or terraform plan -var="inst-count"=3 
#-> terraform apply -var="inst-count"=2  or terraform apply -var="inst-count"=3 
