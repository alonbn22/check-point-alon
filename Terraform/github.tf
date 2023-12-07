# Repository

module "repository" {
  source  = "mineiros-io/repository/github"
  version = "~> 0.18.0"

  for_each = toset(var.repo_names)

  name               = each.key
  default_branch     = var.default_branch
  gitignore_template = "Python"
  visibility         = var.visibility

  webhooks = [
    {
      events       = ["pull_request"]
      url          = "${module.api_gateway.apigatewayv2_api_api_endpoint}/${var.function_name}"
      content_type = "json"
    }
  ]

  depends_on = [
    module.lambda_function,
    module.api_gateway
  ]

}