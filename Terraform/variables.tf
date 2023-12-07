############################
##### GitHub Variables #####
############################

variable "GITHUB_TOKEN" {
  type        = string
  description = "The GitHub token for the repository"
}

variable "repo_names" {
  type        = list(any)
  default     = ["test-github-repository"]
  description = "This list of repository names will be used to create the diffrent repositories"
}

variable "default_branch" {
  type        = string
  default     = "master"
  description = "The main branch of the repositories"
}

variable "visibility" {
  type        = string
  default     = "public"
  description = "The visibility of the repository"
}

#########################
##### AWS Variables #####
#########################

# S3 Bucket

variable "bucket_name" {
  type        = string
  default     = "check-point-logging-bucket"
  description = "The S3 bucket name"
}

variable "bucket_versioning" {
  type        = bool
  default     = true
  description = "If bucket versioning is enabled"
}


# Lambda

variable "function_name" {
  type        = string
  default     = "github-updated-files-lambda"
  description = "The name of the lambda function"
}

variable "python_version" {
  type        = string
  default     = "python3.10"
  description = "The python version for the lambda to run"
}

variable "architectures" {
  type        = list(any)
  default     = ["x86_64"]
  description = "The type of architectures the lambda will use"
}

variable "package_path" {
  type        = string
  default     = "lambda-package.zip"
  description = "The path for the lambda python package"
}

variable "lambda_role_name" {
  type        = string
  default     = "check-point-alon-lambda-role"
  description = "The name of the lambda role"
}

variable "json_policies" {
  type        = list(any)
  default     = ["s3:GetObject*", "s3:PutObject*"]
  description = "Additinal policies for the lambda IAM role"
}

variable "logs_retention_in_days" {
  type        = number
  default     = 1 # Needs to be longer for actual work environments 
  description = "The time in days that the cloudwatch logs will be saved"
}

variable "github_access_token" {
  type        = string
  description = "This is the GitHub access token for the Lambda, it is given as environment varible."
  sensitive   = true
}

# API GateWay

variable "api_gateway_name" {
  type        = string
  default     = "check-point-alon-api-gw"
  description = "The API GateWay name"
}