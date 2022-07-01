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

#Data source to get data from VPC api.It queries default VPC data from our AWS account
data  "aws_vpc" "default-vpc"{
  default = true
  }
#Storing that VPC data to a variable to get the default VPCs ID and subnet ID
data  "aws_subnet_ids" "default-subnet"{
  vpc_id = data.aws_vpc.default-vpc.id
}




#Main code starting
#Creating the Launch Configuration of ASG

resource "aws_launch_configuration" "My-LC" {
  image_id      = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.My-EC2-SG] #created below

  #Adding userdata - optional
  user_data = <<-EOF
  #!/bin/bash
  echo "Hello, World" > index.html
  nohup busybox httpd -f -p ${var.server_port} &   #Referred the variable created above
  EOF

  lifecycle {   #This is required for ASG
    create_before_destroy = true  #it will ensure to create new instance before deleting existing one.
  }

}


#Creating an Auto scaling group
resource "aws_autoscaling_group" "my-ASG" {
  launch_configuration = aws_launch_configuration.My-LC.id
  vpc_zone_identifier = data.aws_subnet_ids.default-subnet.ids
  target_group_arns = [aws_lb_target_group.My-Alb-TG.arn] #Attaching the Load balancer target group to ASG
  health_check_type = "ELB"  # Health check will be done by ELB end
  max_size = 2
  min_size = 5

  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "My-ASG"
  }
}

#Security Group for ASG
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

#Deploying a Load balancer to act as front end
resource "aws_lb" "my-LB" {
  name = "My-ASG-Load-balancer"
  load_balancer_type = "application"
  subnets = [data.aws_subnet_ids.default-subnet.ids]  # Referring the subnet that we got from data resource
  security_groups = [aws_security_group.alb.id]       #Attaching the ALB SG created below
}

#Adding the Listener for Load balancer
resource "aws_lb_listener" "http-listener" {
  load_balancer_arn = aws_lb.my-LB.arn
  protocol = "HTTP"
  port = 80

  #If there is an error then this error page will show
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404:page not Found"
      status_code = "404"
    }
  }
}

#Creating a security group from Load balancer to allow port 80
resource "aws_security_group" "S-alb" {
  name = "My-ALB-SG"

  #Defining rules for incoming
  ingress {
    from_port = 80
    protocol  = "tcp"
    to_port   = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  #Defing rules for outgoing
  egress {
    from_port = 0
    protocol  = "-1"  #means all protocol
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Adding target group of ALB to map ASG backend
resource "aws_lb_target_group" "My-Alb-TG" {
  name = "alb-target-group"
  port = var.server_port
  protocol = "HTTP"
  vpc_id = data.aws_vpc.default-vpc.id

  #Adding health check
  health_check {
    path = "/"
    protocol = "HTTP"
    matcher = "200"  #status code
    interval = 15
    timeout = 3
    healthy_threshold = 2
    unhealthy_threshold = 2
  }

}

# Creating a listener rule to forward the traffic based on header to ASG.

resource "aws_lb_listener_rule" "lb-rule" {
  listener_arn = aws_lb_listener.http-listener.arn
  priority = 100

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.My-Alb-TG.arn
      }
  condition {
    field= "path-pattern"
    values = ["*"]
  }
}


#--------------------CODE COMPLETED---------------------

#To get the DNS of Load balancer as output add the below code:

output "alb_dns_name" {
  description = "The load balancer DNS is:"
  value = aws_lb.my-LB.dns_name

}


