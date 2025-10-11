terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_ssm_parameter" "deployment_version" {
  name        = var.version_param
  description = "Version tag for ${var.project_name} (${var.environment})"
  type        = "String"
  value       = var.deployment_version
  overwrite   = true
}

output "version_param" {
  value = aws_ssm_parameter.deployment_version.name
}