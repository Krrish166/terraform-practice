

provider "aws" {
  region = var.region
  #profile = "dev"
}

module "vpc" {
  source              = "../../modules/vpc"
  cidr_block          = var.vpc_cidr             # ✅ Correct name
  availability_zone   = var.availability_zone      # ✅ Correct name
  public_subnet_cidr  = var.public_subnet_cidr     # ✅ Correct name
  env                 = var.env
}

module "ec2" {
  source        = "../../modules/ec2"
  ami_id = var.ami_id
  instance_type = var.instance_type
  env           = var.env
 subnet_id     = module.vpc.public_subnet_id
  
}

# here first from tfvars we are getting the values to variables.tf after that from variables.tf we are getting to main.tf and from main.tf we are passing to modules
# like this tfvars-->variables.tf-->main.tf-->modules/ec2 and modules/vpc