variable "s3_bucket" {
  description = "The S3 bucket to use as the origin for CloudFront"
  type        = string
}

variable "api_gateway_url" {
  description = "The API Gateway URL to use as the origin for CloudFront"
  type        = string
}