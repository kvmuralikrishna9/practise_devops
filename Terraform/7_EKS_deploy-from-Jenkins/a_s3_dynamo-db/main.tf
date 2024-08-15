# Creating S3 Bucket
resource "aws_s3_bucket" "eks-tf-s3" {
  bucket        = var.bucket_name
  force_destroy = false

  tags = {
    env = var.env_name
  }
}

/*
# Enablin the bucket versioning option
resource "aws_s3_bucket_versioning" "eks-tf-s3_versioning" {
  bucket = aws_s3_bucket.eks-tf-s3.id
  versioning_configuration {
    status = "Enabled"
  }
}
*/

# Creating DynamoDB table
resource "aws_dynamodb_table" "eks-tf-dynamo-db" {
  name         = var.dynamo-db_name
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"
  #stream_view_type = "NEW_AND_OLD_IMAGES"
  #deletion_protection_enabled = false

  attribute {
    name = "LockID"
    type = "S"
  }

  /*
  replica {
    region_name = var.replica_region
  }
*/

  tags = {
    env = var.env_name
  }
}
