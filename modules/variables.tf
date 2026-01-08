variable "ami" {
  type = string
  default = ""
}

variable "instance_type" {
  type = string
  default = ""
}

variable "availability_zone" {
  type = string
  default = ""
}
variable "subnet_id" {
  type = string
}

variable "tags" {
  type = map(string)
  default = {}
  
}