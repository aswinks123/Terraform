#Creating iam user using the variable that we defined below
resource "aws_iam_user" "my-users" {
  count = length(var.count-user-variable)  #get the total number of elements in the list

  name = var.count-user-variable[count.index]  # extract elements from list 
}



#Declaring variable that store the usernames as list
variable "count-user-variable" {

  description = "IAM username"
  type  = list(string)
  default = ["user1","user2","user3"]
}