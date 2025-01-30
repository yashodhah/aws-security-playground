resource "aws_s3_bucket" "appbucket" {
  bucket = "appbucket-example" # Replace with your bucket name

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  public_access_block {
    block_public_acls       = false
    block_public_policy     = false
    ignore_public_acls      = false
    restrict_public_buckets = false
  }
}

resource "aws_s3_bucket_policy" "appbucket_policy" {
  bucket = aws_s3_bucket.appbucket.id

  policy = jsonencode({
    Version   = "2012-10-17"
    Id        = "MyPolicy"
    Statement = [
      {
        Sid       = "PublicReadForGetBucketObjects"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.appbucket.arn}/*"
      }
    ]
  })
}

resource "aws_s3_bucket" "patchesprivatebucket" {
  bucket = "patchesprivatebucket-example" # Replace with your bucket name

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]
  }
}
