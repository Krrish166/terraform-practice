variable "ami" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
  default = ""
}

variable "instancetype" {
  type = string
  default = ""
}

variable "virginia_ami" {
  type = string
  default = ""
}

variable "virginia_type" {
  type = string
  default = ""
}