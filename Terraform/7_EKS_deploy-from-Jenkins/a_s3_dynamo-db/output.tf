output "s3_bucket_id" {
  value = aws_s3_bucket.eks-tf-s3.id
}

output "dynamo-db_name" {
  value = aws_dynamodb_table.eks-tf-dynamo-db.name
}