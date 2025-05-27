output "glue_database_name" {
  value = aws_glue_catalog_database.s3_schema_db.name
}

output "glue_crawler_name" {
  value = aws_glue_crawler.s3_crawler.name
}