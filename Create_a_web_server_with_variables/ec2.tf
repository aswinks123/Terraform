#Defining the provider
provider "aws" {
  region = "us-east-1"

}

#Defining the variable for server port that will be referred by below codes.
variable "server_port" {
description = "The port the server will use for HTTP requests"
type = number
default = 8080
}


# Create an EC2 instance

resource "aws_instance" "my-instance" {

  ami = ">AMI-ID>"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.My-EC2-SG.id]   #This ID we got from referring the SG we created below
  #Adding user data to EC2 to run a web server
  user_data = <<-EOF
  #!/bin/bash
  echo "Hello, World" > index.html
  nohup busybox httpd -f -p ${var.server_port} &   # Referred the variable created above
  EOF


# Adding tag

  tags = {
    Name  = "MyFirstInstance"
  }
}

# Create a Security Group for our Instance

resource "aws_security_group" "My-EC2-SG" {
  name = "EC2-SG"

  #Mentioning the ports required to open.We can add multiple ingress in this SG

  ingress {
    from_port = var.server_port   #Referred the variable created above
    protocol  = "tcp"
    to_port   = var.server_port
    cidr_blocks = ["0.0.0.0/0"]
  }

}




