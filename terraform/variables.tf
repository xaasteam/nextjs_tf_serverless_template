variable "region" {
  default = "us-east-1"
  type    = string
}

variable "artifact_store_bucket_name" {
  type = string
  default = "test"
}

variable "ecs_task_execution_iam_role" {
  type = object({
    arn : string
  })
  default = {
    arn = "test"
  }
}

variable "service_name" {
  type = string
  default = "test"
}
variable "env" {
  default = "test"
  type    = string
}
variable "api_gateway_id" {
  default = "test"
}
variable "api_gateway_base_path_mapping" {
  type = string
  default = "test"
}
variable "hosted_zone_name" {
  type = string
  default = "test"
}
variable "hosted_zone_id" {
  type = string
  default = "test"
}
variable "acm_cert_arn" {
  type = string
  description = "ARN of the ACM certificate"

  validation {
    condition     = can(regex("^arn:aws:acm:[a-z0-9-]+:[0-9]{12}:certificate/[a-z0-9-]+$", var.acm_cert_arn))
    error_message = "The ACM certificate ARN must be a valid ARN."
  }
  default = "arn:aws:acm:region:account-id:certificate/certificate-id"
}

variable "vpc_id" {
  default = "test"
}
variable "private_subnet_mappings" {
  type = map(any)
  default = {
    default = {
    "a" = { id = "subnet-12345678" }
    "b" = { id = "subnet-87654321" }
  }
  }
}
# variable "bastion_security_group" {}

variable "artifact_store_bucket" {
  default = "test"
  type    = string
}
variable "subdomain" {
  type = string
  default = "test"
}
variable "secrets" {
  type = map(string)
  default = {
    "name" = "value"
  }
}


variable "AWS_ACCESS_KEY_ID" {
  default = "test"
}
variable "AWS_SECRET_ACCESS_KEY" {
  default = "test"
}
variable "AWS_DEFAULT_REGION" {
  default = "us-east-1"
}