output "primary_endpoint" {
    value = aws_db_instance.rds_instance.endpoint
  
}

output "read_replica_endpoint" {
    value = aws_db_instance.read_replica.endpoint
  
}