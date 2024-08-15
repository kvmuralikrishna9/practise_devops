output "s3_bucket_id" {
  value = aws_s3_bucket.vrp-tfstate-s3.id
}

output "dynamo-db_name" {
  value = aws_dynamodb_table.vrp-tfhcllock.name
}