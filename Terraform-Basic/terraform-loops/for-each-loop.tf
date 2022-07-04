#for-each loop


#Creating iam user using the variable that we defined below
resource "aws_iam_user" "my-users" {
  for_each = var.count-user-variable  #iterate to each element

  name = each.value #Assigning the iterated value to name
}



#Declaring variable that store the usernames as list
variable "count-user-variable" {

  description = "IAM username"
  type  = set(string)         #We can only use for_each for set and map
  default = ["usera","userb","userc"]
}