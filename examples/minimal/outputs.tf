output "organization_name" {
  description = "GitHub organization name"
  value       = module.github_org.name
}

output "teams" {
  description = "Created teams"
  value       = module.github_org.teams
}

output "members" {
  description = "Organization members"
  value       = module.github_org.members
}
