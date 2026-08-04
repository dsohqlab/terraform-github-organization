variable "github_owner" {
  description = "GitHub organization name used by the provider and module settings."
  type        = string
}

variable "github_token" {
  description = "GitHub token with permissions to manage the organization."
  type        = string
  sensitive   = true
}

variable "billing_email" {
  description = "Billing email address for the GitHub organization."
  type        = string
}

variable "org_email" {
  description = "Public contact email for the GitHub organization profile."
  type        = string
}

variable "seed_admin_username" {
  description = "Existing GitHub username to grant organization admin access."
  type        = string
}

variable "blocked_username" {
  description = "GitHub username to demonstrate blocked member management."
  type        = string
}

variable "fork_source_owner" {
  description = "Owner of the upstream repository used by the fork example."
  type        = string
}

variable "fork_source_repository" {
  description = "Repository name of the upstream repository used by the fork example."
  type        = string
}

variable "npm_token" {
  description = "Plaintext organization actions secret shared with selected repositories."
  type        = string
  sensitive   = true
}

variable "audit_webhook_token" {
  description = "Plaintext organization secret for outbound audit integrations."
  type        = string
  sensitive   = true
}

variable "dependabot_token_encrypted" {
  description = "Encrypted Dependabot secret value produced with the organization's public key."
  type        = string
  sensitive   = true
}

variable "webhook_url" {
  description = "Destination URL for the organization webhook example."
  type        = string
}

variable "webhook_secret" {
  description = "Shared secret for the organization webhook example."
  type        = string
  sensitive   = true
}
