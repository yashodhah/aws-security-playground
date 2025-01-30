resource "aws_cloudfront_distribution" "webapp_cdn" {
  origin {
    domain_name = aws_s3_bucket.appbucket.bucket_regional_domain_name
    origin_id   = "appbucket"

    s3_origin_config {
      origin_access_identity = "" # Add if using OAI
    }
  }

  default_cache_behavior {
    target_origin_id       = "appbucket"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = true
    }
  }

  enabled             = true
  default_root_object = "index.html"
}
