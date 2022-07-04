#for loop



#Declaring variable that store the usernames as list
variable "count-user-variable" {

  description = "IAM username"
  type  = set(string)         #We can only use for_each for set and map
  default = ["usera","userb","userc"]
}


#We are outputing the data using for loop syntax
output "print-users" {
  description = "just print the username defined in variable created above"
  value =[for i in var.count-user-variable : i]   #extracting using for loop
}


