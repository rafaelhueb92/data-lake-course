resource "aws_glue_catalog_database" "s3_schema_db" {
  name        = "${var.name}-glue-db"
  description = "Database to store schemas from S3 data from ${var.name}"
}

resource "aws_iam_role" "glue_crawler_role" {
  name = "glue-crawler-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "glue.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "glue_service" {
  role       = aws_iam_role.glue_crawler_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_iam_role_policy" "s3_access" {
  name = "s3-access-policy-${var.name}"
  role = aws_iam_role.glue_crawler_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Effect   = "Allow"
        Resource = [
          "arn:aws:s3:::${var.name}",
          "arn:aws:s3:::${var.name}/*"
        ]
      }
    ]
  })
}

# Create the Glue Crawler
resource "aws_glue_crawler" "s3_crawler" {
  name          = var.name
  role          = aws_iam_role.glue_crawler_role.arn
  database_name = aws_glue_catalog_database.s3_schema_db.name
  
  s3_target {
    path = "s3://${var.name}/brass/"
    # Optional: Exclude patterns
    # exclusions = ["*.tmp", "*.temp"]
  }

  # Optional: Configure the crawler schedule
  # schedule = "cron(0 12 * * ? *)"  # Run daily at noon UTC
  
  configuration = jsonencode({
    Version = 1.0
    CrawlerOutput = {
      Partitions = { AddOrUpdateBehavior = "InheritFromTable" }
    }
  })

  # Optional: Schema change policy
  schema_change_policy {
    delete_behavior = "LOG"  # Options: LOG, DELETE_FROM_DATABASE, DEPRECATE_IN_DATABASE
    update_behavior = "UPDATE_IN_DATABASE"  # Options: LOG, UPDATE_IN_DATABASE
  }

  # Optional: Configure classification
  classifiers = []  # Add custom classifiers if needed
}