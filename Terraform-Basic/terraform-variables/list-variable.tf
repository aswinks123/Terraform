resource "aws_iam_user" "user-1" {

  #Assigning the variable
  count = length(var.user-name)
  name = var.user-name[count.index]  #It iterate through the list one by one
}





#Crearing list variable for instance count

variable "user-name" {
  description = "IAM_User"
  type = list(string)
  default = ["user-1","user-2","user3"]
}