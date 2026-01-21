# resource "aws_instance" "name" {
#   ami = "ami-0ced6a024bb18ff2e"
#   instance_type = "t2.micro"
#   count = 2
#   tags = {
#     Name="dev"
#   }
# }

variable "env" {
  type = list(string)
  default = ["prod"] # 0,1,2
}

resource "aws_instance" "name" {
  ami = "ami-0ced6a024bb18ff2e"
  instance_type = "t2.micro"
  count = length(var.env) # it will check the length of the list and create that many instances
  tags = {
    Name = var.env[count.index]  # it will assign the name based on the index of the list
  }
}

# terraform tracks the server by index number starting from 0
# so if we have 2 instances and we delete 1st instance then 2nd instance will be renamed to 1st instance
# to avoid this we can use for_each instead of count