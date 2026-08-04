output "organization_name" {
  description = "GitHub organization login name."
  value       = module.organization.name
}

output "organization_display_name" {
  description = "GitHub organization display name."
  value       = module.organization.display_name
}

output "team_ids" {
  description = "Team IDs created by the module."
  value       = module.organization.teams
}

output "members" {
  description = "Organization members managed by the module."
  value       = module.organization.members
}

output "secret_metadata" {
  description = "Created organization secret metadata."
  value       = module.organization.secrets
}

output "dependabot_secret_metadata" {
  description = "Created Dependabot secret metadata."
  value       = module.organization.bot_secrets
}

output "webhook_urls" {
  description = "Webhook URLs managed by the module."
  value       = module.organization.webhook_urls
}
