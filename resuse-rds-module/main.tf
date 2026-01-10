module "my-db" {
    source = "../rds-custom-module"
    engine               = "mysql"
    engine_version       = "8.0"
    instance_class       = "db.t3.micro"
    allocated_storage    = 20
    db_name              = "mydatabase"
    username             = "admin"
    password             = "YourSecurePassword123!"
    identifier           = "my-rds-instance"

    
    tags                 = {
        Name = "my-rds-instance"
    }
    backup_retention_period = 7
    deletion_protection    = false
    backup_window = "02:00-03:00"
    parameter_group_name = "default.mysql8.0"
    skip_final_snapshot = true
    
    
    

}