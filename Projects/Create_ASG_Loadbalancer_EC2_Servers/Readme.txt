Resources in this Session

This code will deploy the following Resource


1. Autoscaling group. name "my-ASG"
1.1 Launch configuration of ASG . name "My-LC"
1.2 Security group for Launch configuration. name "My-EC2-SG""


2. Load Balancer name "my-LB"
2.1 Listener for Load balancer. name "http-listener"
2.2 Security group for ALB. name "S-alb"
2.3 Load balancer target group. name "My-Alb-TG"
2.4 Load balancer listener rule. name "lb-rule"



Variables contents:

alb_dns_name : Have Load balancer DNS name
server_port : 8080
