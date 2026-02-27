# outputs.tf defines the values terraform will print to the terminal after terraform apply completes
# this will be helpful for the lamdba function to connect the s3 bucket to the postgres database


output "s3_bucket_name" {
    description = "The name of the uploads bucket, including the random suffix"
    value = aws_s3_bucket.uploads.bucket
}

output "rds_endpoint" {
    description = "The connection endpoint for the Postgres database"
    value = aws_db_instance.postgres.endpoint
}

output "rds_db_name" {
    description = "The name of the Postgres database inside the RDS instance"
    value = aws_db_instance.postgres.db_name
}