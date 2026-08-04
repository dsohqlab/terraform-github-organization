output "name" {
  description = "GitHub Organization Name."
  value       = var.settings.name
}

output "display_name" {
  description = "GitHub Organization Display Name."
  value       = var.settings.display_name
}

output "teams" {
  description = "Teams with GitHub identifiers."
  value       = { for name, team in var.teams : name => github_team.this[name].id }
}

output "members" {
  description = "GitHub organization members."
  value       = keys(var.members)
}

output "secrets" {
  description = "A map of create secret names"
  value = { for name, secret in github_actions_organization_secret.this : name => {
    created = secret.created_at
    updated = secret.updated_at }
  }
}

output "bot_secrets" {
  description = "A map of create dependabot secret names"
  value = { for name, secret in github_dependabot_organization_secret.this : name => {
    created = secret.created_at
    updated = secret.updated_at }
  }
}

output "webhook_urls" {
  description = "Webhook URLs"
  value       = { for k, v in github_organization_webhook.this : k => v.url }
}
