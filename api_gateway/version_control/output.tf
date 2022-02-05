output "dynamodb_table_name" {
  value       = aws_dynamodb_table.dynamodb-terraform-state-lock.name
  description = "The name of the DynamoDB table"
}

output "s3_bucket_name" {
  value = aws_s3_bucket.backend-bucket.id
  description = "The name of the S3 bucket"
}