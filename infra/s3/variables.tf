# variables.tf

variable "bucket_name" {
  description = "Base name for the S3 bucket (will be concatenated with AWS account ID)"
  type        = string
}

variable "environment" {
  description = "Environment tag for the bucket"
  type        = string
  default     = "dev"
}
