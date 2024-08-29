variable "function_name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "s3_bucket" {
  description = "The S3 bucket where the Lambda code is stored"
  type        = string
}