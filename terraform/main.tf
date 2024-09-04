data "aws_caller_identity" "current" {}
locals {
  service_name = "nextjs-tf-aws-template"
  domain_name  = "nextjs-tf-aws-template"
}
# provider "aws" {
#   region = "us-east-1"
#   # alias  = "east"
# }

provider "aws" {
  access_key                  = var.AWS_ACCESS_KEY_ID
  secret_key                  = var.AWS_SECRET_ACCESS_KEY
  region                      = var.AWS_DEFAULT_REGION
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  endpoints {
    apigateway     = "http://localhost:4566"
    cloudformation = "http://localhost:4566"
    cloudwatch     = "http://localhost:4566"
    dynamodb       = "http://localhost:4566"
    es             = "http://localhost:4566"
    firehose       = "http://localhost:4566"
    iam            = "http://localhost:4566"
    kinesis        = "http://localhost:4566"
    lambda         = "http://localhost:4566"
    route53        = "http://localhost:4566"
    redshift       = "http://localhost:4566"
    s3             = "http://localhost:4566"
    secretsmanager = "http://localhost:4566"
    ses            = "http://localhost:4566"
    sns            = "http://localhost:4566"
    sqs            = "http://localhost:4566"
    ssm            = "http://localhost:4566"
    stepfunctions  = "http://localhost:4566"
    sts            = "http://localhost:4566"
  }
}


module "nextjs_lambda_frontend_base" {
  # depends_on = [aws_api_gateway_integration.api_gateway_root_resource_method_integration]
  source = "./base"

  base_domain_name       = local.domain_name
  service_name           = local.service_name
  api_gateway_stage_name = "dev"
}



module "nextjs_lambda" {
  # depends_on = [aws_api_gateway_integration.api_gateway_root_resource_method_integration]
  depends_on                  = [module.nextjs_lambda_frontend_base]
  source                      = "./main"
  env                         = var.env
  service_name                = var.service_name
  vpc_id                      = var.vpc_id
  hosted_zone_id              = var.hosted_zone_id
  hosted_zone_name            = var.hosted_zone_name
  ecs_task_execution_iam_role = var.ecs_task_execution_iam_role
  api_gateway_id              = var.api_gateway_id
  private_subnet_mappings     = var.private_subnet_mappings
  acm_cert_arn                = var.acm_cert_arn
  artifact_store_bucket       = var.artifact_store_bucket
  # bastion_security_group = var.bastion_security_group
  api_gateway_base_path_mapping = var.api_gateway_base_path_mapping
  subdomain                     = var.subdomain
  secrets                       = var.secrets
}
