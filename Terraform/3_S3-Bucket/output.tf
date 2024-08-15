output "s3-bucket-id" {
  value = aws_s3_bucket.VRP-documents.id
}

output "s3-bucket-name" {
  value = aws_s3_bucket.VRP-documents.region
}

output "s3-bucket-tag" {
  value = aws_s3_bucket.VRP-documents.tags
}
