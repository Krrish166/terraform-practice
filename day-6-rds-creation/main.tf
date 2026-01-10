resource "aws_vpc" "rds_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "rds-vpc"
  }
  
}

resource "aws_subnet" "rds_subnet_1" {
  vpc_id     = aws_vpc.rds_vpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "rds-subnet-1"
  }
  availability_zone = "ap-south-1a"
}

resource "aws_subnet" "rds_subnet_2" {
  vpc_id     = aws_vpc.rds_vpc.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "rds-subnet-2"
  }
  availability_zone = "ap-south-1b"
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.rds_subnet_1.id, aws_subnet.rds_subnet_2.id]
  tags = {
    Name = "rds-subnet-group"
  }
}

resource "aws_security_group" "rds_security_group" {
  name        = "rds-security-group"
  description = "Security group for RDS instances"
  vpc_id      = aws_vpc.rds_vpc.id


  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # allow from VPC
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-security-group"
  }
}

resource "aws_db_instance" "rds_instance" {
  identifier        = var.identifier
  allocated_storage = var.allocated_storage
  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  # change username and password as needed
  db_name  = var.db_name
#   manage_master_user_password = true # let Terraform manage the password from secerets manager
  username = var.username
  password = var.password
  # configure a subnet group and security group for RDS
  db_subnet_group_name   = var.aws_db_subnet_group
  vpc_security_group_ids = var.vpc_security_group_ids

  
  publicly_accessible = false
  tags = var.tags

    # Enable monitoring (CloudWatch Enhanced Monitoring)
  monitoring_interval      = 60  # Collect metrics every 60 seconds
  monitoring_role_arn      = aws_iam_role.rds_monitoring.arn
  
  parameter_group_name = "default.mysql8.0"

   # Enable backups and retention
  backup_retention_period  = 7   # Retain backups for 7 days
  backup_window            = "02:00-03:00" # Daily backup window (UTC)

  # Enable deletion protection
   deletion_protection  = false
  
  # Final snapshot before deletion
  skip_final_snapshot = true

}


# # IAM Role for RDS Enhanced Monitoring
resource "aws_iam_role" "rds_monitoring" {
  name = "rds-monitoring-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "monitoring.rds.amazonaws.com"
      }
    }]
  })
}

#IAM Policy Attachment for RDS Monitoring
resource "aws_iam_role_policy_attachment" "rds_monitoring_attach" {
  role       = aws_iam_role.rds_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

# create read replica
resource "aws_db_instance" "read_replica" {
  identifier             = "my-rds-read-replica"
  replicate_source_db   = aws_db_instance.rds_instance.arn
  instance_class         = "db.t3.micro"
  publicly_accessible    = false
  tags = {
    Name = "my-rds-read-replica"
  }
  # configure a subnet group and security group for RDS read replica
    db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
    vpc_security_group_ids = [aws_security_group.rds_security_group.id]
   # Final snapshot before deletion
    skip_final_snapshot = false
   
   # Ensure the read replica is created after the primary instance
    depends_on = [
    aws_db_instance.rds_instance
  ]
}   