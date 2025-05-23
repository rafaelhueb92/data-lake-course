# main.tf

data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  bucket_name = "${var.bucket_name}-${local.account_id}"
}

resource "aws_s3_bucket" "data_bucket" {
  bucket = local.bucket_name
  
  tags = {
    Name = local.bucket_name
    Environment = var.environment
  }
}

resource "aws_s3_object" "brass_folder" {
  bucket = aws_s3_bucket.data_bucket.id
  key    = "brass/"
  content_type = "application/x-directory"
}

resource "aws_s3_object" "silver_folder" {
  bucket = aws_s3_bucket.data_bucket.id
  key    = "silver/"
  content_type = "application/x-directory"
}

resource "aws_s3_object" "gold_folder" {
  bucket = aws_s3_bucket.data_bucket.id
  key    = "gold/"
  content_type = "application/x-directory"
}
