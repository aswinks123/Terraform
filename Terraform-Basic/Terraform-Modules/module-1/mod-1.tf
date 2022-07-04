#We are creating a EC2 Instance in Module-1

#We will add this module to our main project module.





#Creating EC2

resource "aws_instance" "ec2_example" {

    ami = "ami-0767046d1677be5a0"
    instance_type = "t2.micro"
    key_name= "aws_key"
    vpc_security_group_ids = [aws_security_group.main.id]

user_data = <<-EOF
      #!/bin/sh
      sudo apt-get update
      sudo apt install -y apache2
      sudo systemctl status apache2
      sudo systemctl start apache2
      sudo chown -R $USER:$USER /var/www/html
      sudo echo "<html><body><h1>Hello this is module-1 server </h1></body></html>" > /var/www/html/index.html
      EOF
}



#Creating a Security group for EC2

resource "aws_security_group" "main" {
    name        = "EC2-webserver-SG-2"
    description = "Webserver for EC2 Instances"

    ingress {
        from_port   = 80
        protocol    = "TCP"
        to_port     = 80
        cidr_blocks = ["0.0.0.0/0"]
    }
}


