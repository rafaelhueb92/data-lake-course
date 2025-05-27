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

module "crawler" { 
   source = "./crawler"
   name = local.bucket_name
}