module "data_lake_demographics" {
  source      = "./s3"
  bucket_name = "data-lake-demographics"
}

output "bucket_name" {
  value = module.data_lake_demographics.bucket_name
}
