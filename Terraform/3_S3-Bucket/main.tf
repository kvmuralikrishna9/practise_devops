# Creating S3 Bucket
resource "aws_s3_bucket" "VRP-documents" {
  bucket        = var.bucket_name
  force_destroy = false

  tags = {
    env = var.env_name
  }
}

# Enabling the bucket versioning option
resource "aws_s3_bucket_versioning" "VRP-documents-s3_versioning" {
  bucket = aws_s3_bucket.VRP-documents.id
  versioning_configuration {
    status = "Enabled"
  }
}