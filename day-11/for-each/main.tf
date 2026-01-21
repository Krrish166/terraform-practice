
variable "env" {
    type = list(string)
    default = ["dev", "prod"]
  
}

resource "aws_instance" "name" {
    ami = "ami-0ced6a024bb18ff2e"
    instance_type = "t2.micro"
    for_each = toset(var.env) # toset not folows any order like list (index)
    tags = {
        Name = each.value
    }
}