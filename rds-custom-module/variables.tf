variable "identifier" {
  type = string
 
}

variable "engine" {
  type = string
  
}

variable "engine_version" {
  type = string
 
}
variable "instance_class" {
  type = string
 
}

variable "allocated_storage" {
  type = number
}

variable "db_name" {
  type = string
  
}

variable "username" {
  description = "The master username for the RDS instance"
  type        = string
  
}

variable "password" {
  description = "The master password for the RDS instance"
  type        = string
  
}


variable "tags" {
  type = map(string)
 
}

variable "parameter_group_name" {
  type = string
 
  
}
variable "backup_retention_period" {
  type = number
 
}

variable "backup_window" {
  type = string

  
}

variable "deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot"
  type        = bool
  
}