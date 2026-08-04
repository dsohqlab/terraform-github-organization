# Use this data source to retrieve basic information about a GitHub Organization.
data "github_organization" "this" {
  name = var.settings.name
}

# Use this data source to retrieve information about a GitHub Actions Organization public key. This data source is required to be used with other GitHub secrets interactions.
data "github_actions_organization_public_key" "this" {}

# Use this data source to retrieve information about a GitHub Dependabot Organization public key. This data source is required to be used with other GitHub secrets interactions.
data "github_dependabot_organization_public_key" "this" {}

# Use this data source to retrieve information about a GitHub repository.
data "github_repository" "managed" {
  for_each  = toset(distinct(flatten(concat([for k, v in var.secrets : v.repositories], [for k, v in var.bot_secrets : v.repositories], ))))
  full_name = "${data.github_organization.this.login}/${each.value}"
}
