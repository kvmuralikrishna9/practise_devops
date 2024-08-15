variable "eks-region" {
  description = "Region where EKS will be created"
}

variable "bucket_name" {
  description = "S3 Bucket Name"
}

variable "env_name" {
  description = "S3 Bucket Name"
}

variable "dynamo-db_name" {
  description = "Dynamo-DB Name"
}

/* 
variable "replica_region" {
  description = "Dynamo-DB Replica Region"
}
*/