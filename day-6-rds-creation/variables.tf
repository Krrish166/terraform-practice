variable "identifier" {
  type = string
  default = ""
}

variable "engine" {
  type = string
  default = ""
}

variable "engine_version" {
  type = string
  default = ""
}
variable "instance_class" {
  type = string
  default = ""
}

variable "allocated_storage" {
  type = number
  default = ""
}

variable "db_name" {
  type = string
  default = ""
}

variable "username" {
  description = "The master username for the RDS instance"
  type        = string
  default     = ""
}

variable "password" {
  description = "The master password for the RDS instance"
  type        = string
  default     = ""
}

variable "port" {
  type = string
  default = ""
  
}
variable "aws_db_subnet_group" {
  type = string
  default = ""
}

variable "vpc_security_group_ids" {
  type = list(string)
  default = []
}
variable "subnet_ids" {
  type = list(string)
  default = []
}


variable "tags" {
  type = map(string)
  default = {}
}

variable "parameter_group_name" {
  type = string
  default = ""
  
}
variable "backup_retention_period" {
  type = number
  default = ""
}

variable "backup_window" {
  type = string
  default = ""
  
}


