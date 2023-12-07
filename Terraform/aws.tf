# S3

module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = var.bucket_name
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = var.bucket_versioning
  }
}

# Lambda

module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = var.function_name
  description   = "This Lambda will figure out if a PR was merged and will log the files changed into an S3"
  handler       = "lambda_function.lambda_handler"
  runtime       = var.python_version
  architectures = var.architectures

  create_package         = false
  local_existing_package = var.package_path

  create_role = true
  role_name   = var.lambda_role_name

  policy_jsons = var.json_policies

  timeout = 60

  cloudwatch_logs_retention_in_days = var.logs_retention_in_days

  environment_variables = {
    github_access_token = var.github_access_token
    bucket_name         = module.s3_bucket.s3_bucket_id
  }

  depends_on = [
    module.s3_bucket
  ]
}

# Policy attachment for the Lambda role

data "aws_iam_policy_document" "policy" {
  statement {
    effect    = "Allow"
    actions   = var.json_policies
    resources = ["${module.s3_bucket.s3_bucket_arn}/*"]
  }
}

resource "aws_iam_policy" "policy" {
  name        = "s3-allow-logging"
  description = "Allows the lambda to use the S3 bucket for logging"
  policy      = data.aws_iam_policy_document.policy.json
}


resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = module.lambda_function.lambda_role_name
  policy_arn = aws_iam_policy.policy.arn
}


# API GateWay

module "api_gateway" {
  source = "terraform-aws-modules/apigateway-v2/aws"

  name          = var.api_gateway_name
  description   = "API GateWay that will trigger the GitHub updated files lambda with github webhook"
  protocol_type = "HTTP"

  # Custom domain
  create_api_domain_name = false

  # Routes and integrations
  integrations = {
    "POST /${var.function_name}" = {
      lambda_arn             = module.lambda_function.lambda_function_arn
      integration_type       = "AWS_PROXY"
      payload_format_version = "2.0"
      timeout_milliseconds   = 12000
    }
  }

}