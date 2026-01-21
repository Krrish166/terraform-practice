module "vpc" {
  source       = "./modules/vpc"
  cidr_block   = "10.0.0.0/16"
  subnet_1_cidr  = "10.0.1.0/24"
  subnet_2_cidr = "10.0.2.0/24"
  az1           = "ap-south-1a"
  az2           = "ap-south-1b"
}

module "ec2" {
   source        = "./modules/ec2"
   ami_id        = "ami-00ca570c1b6d79f36"  # Replace with valid AMI
   instance_type = "t2.micro"
   subnet_1_id     = module.vpc.subnet_1_id
}

module "rds" {
  source         = "./modules/rds"
  subnet_1_id      = module.vpc.subnet_1_id
  subnet_2_id      = module.vpc.subnet_2_id
  instance_class = "db.t3.micro"
  db_name        = "mydb"
  db_user        = "admin"
  db_password    = "Admin12345"
}

module "s3" {
    source = "./modules/s3"
    bucket = "my-heleo-user"
  

}

