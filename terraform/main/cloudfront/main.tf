resource "aws_s3_bucket" "bucket" {
  bucket = "${var.service_name}-${var.env}-${var.region}-cloudfront"

  tags = {
    env = var.env,
    region = var.region,
    Service = var.service_name
  }
}
resource "aws_s3_bucket_ownership_controls" "s3_bucket_ownership_controls" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    object_ownership = "ObjectWriter"
  }
}
resource "aws_s3_bucket_acl" "b_acl" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "public-read"
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_ownership_controls]
}

locals {
  s3_origin_id = "myS3Origin"
}
resource "aws_cloudfront_origin_access_control" "default" {
  name                              = "${var.service_name}-${var.env}-${var.region}-cloudfront-policy"
  description                       = "${var.service_name}-${var.env}-${var.region}-cloudfront-policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
resource "aws_cloudfront_response_headers_policy" "cloudfront_response_headers_policy" {
  name    = "${var.service_name}-${var.env}-${var.region}-cloudfront_response_headers_policy"
  comment = "${var.service_name}-${var.env}-${var.region}-cloudfront_response_headers_policy"

  cors_config {
     access_control_allow_credentials = false

    access_control_allow_headers {
      items = ["*"]
    }

    access_control_allow_methods {
      items = ["GET"]
    }

    access_control_allow_origins {
      items = var.cors_allowed_hosts
    }

    origin_override = true
  }
}
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
    origin_id                = local.s3_origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "index.html"

/*
  logging_config {
    include_cookies = false
    bucket          = "mylogs.s3.amazonaws.com"
    prefix          = "myprefix"
  }
*/

  aliases = [  "${var.subdomain}.${var.hosted_zone_name}" ]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    response_headers_policy_id = aws_cloudfront_response_headers_policy.cloudfront_response_headers_policy.id
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "/content/immutable/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  # Cache behavior with precedence 1
  ordered_cache_behavior {
    path_pattern     = "/content/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  tags = {
    env = var.env,
    region = var.region,
    Service = var.service_name
  }

  viewer_certificate {
    acm_certificate_arn = var.acm_cert_arn
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}