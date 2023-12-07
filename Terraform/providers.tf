terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "5.42.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.28.0"
    }
  }
}

provider "github" {
  # Configuration options
  token = var.GITHUB_TOKEN
}

provider "aws" {
  # Configuration options
}