variable "github_owner" {
  description = "GitHub organization owner (username or org name)"
  type        = string
}

variable "github_token" {
  description = "GitHub personal access token with admin:org scope"
  type        = string
  sensitive   = true
}

variable "billing_email" {
  description = "Billing email for the organization"
  type        = string
}
