variable "project_name" {
  description = "Name of the project or repository"
  type        = string
}

variable "image_full" {
  description = "Full ECR image path (registry/repo:tag)"
  type        = string
}

variable "environment" {
  description = "Environment name (Development or Production)"
  type        = string
}

variable "version_param" {
  description = "Parameter Store name to update with the version"
  type        = string
}

variable "deployment_version" {
  description = "Unique deployment version string"
  type        = string
}