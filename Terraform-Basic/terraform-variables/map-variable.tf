resource "aws_instance" "my-instance" {
  ami = "ami-0b0ea68c435eb488d"
  instance_type = "t2.micro"
  count = 1

  tags = var.project_env   #assigned map value to tag

}
#Crearing map variable for instance count

variable "project_env" {
  description = "project and environment details"
  type = map(string)
  default = {
    project = "project-1"
    environment = "dev"
  }
}